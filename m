Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYHVQxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYHVQxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYHVQxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:53:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYHVQxX convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:53:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
Date: Fri, 22 Aug 2008 18:52:37 +0200
User-Agent: KMail/1.9.9
Cc: "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD0101.4020505@gmail.com> <48AE19AD.1020209@lougher.demon.co.uk> <6934efce0808212005h30fa16d8w48833e8a0becfd8c@mail.gmail.com>
In-Reply-To: <6934efce0808212005h30fa16d8w48833e8a0becfd8c@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808221852.38950.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+l4erW0XjgBZOLpXvMvXWnGO0zbPQlm2H3ey6
 bKh8d6CYVfkmDT3yYCokhjQPcxm8ETFfkV473/rLsRVyWjzFmt
 J6iSHZX+4hme+AyrdehTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Jared Hulbert wrote:
> > This implies for block devices that the entire filesystem metadata has to be
> > cached in RAM.  This severely limits the size of AXFS filesystems when using
> > block devices, or the else memory usage will be excessive.
> 
> This is where 64bit squashfs could be a better fit.

Is this the only place where squashfs has a significant advantage? 
If so, you might want to change it in axfs eventually to make the
decision easier for users ;-)

It certainly sounds like something for your medium-term TODO list,
although I wouldn't think of it as a show-stopper.

	Arnd <><
