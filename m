Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYHVUiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYHVUiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYHVUif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:38:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbYHVUid convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:38:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Date: Fri, 22 Aug 2008 22:37:19 +0200
User-Agent: KMail/1.9.9
Cc: "David Woodhouse" <dwmw2@infradead.org>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com,
       nickpiggin@yahoo.com.au
References: <48AD00F8.1030004@gmail.com> <200808211339.37187.arnd@arndb.de> <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
In-Reply-To: <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808222237.20346.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Y3agoKghSIUlR8XjdfWe3rt10mlok2rToTk0
 h3DL5WFxosWq6lbLo9UMOWUa2eJyDip94wZj+e5CPZD7ZYjyCV
 tWngfZ/y19LtR5U2/uyHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> 1) same mount point -
> I don't see how this works without an ioctl.  I can't just make up
> files in my mounted filesystem.   You expect the mounted version to
> match input to the mkfs.  I'd not be happy with an ioctl.  You can
> just read it.
> 
> 2) sysfs -
> I agree with Carsten, I don't see how this fits in the sysfs hierarchy.
> 
> 3) debugfs -
> I don't know diddly about this.

Ok, so now yet another suggestion, which may sound a little strange:

oprofilefs

I believe you can use the oprofile infrastructure to record data
about file accesses, even independent of the file system you
are looking at.

It's probably a lot of work to get it right, but I would be worth it.

	Arnd <><
