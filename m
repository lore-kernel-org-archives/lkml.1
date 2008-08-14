Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYHNNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYHNNCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYHNNCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:02:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYHNNCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:02:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: TALPA - a threat model?  well sorta.
Date: Thu, 14 Aug 2008 15:00:59 +0200
User-Agent: KMail/1.9.9
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, andi@firstfloor.org, riel@redhat.com,
       greg@kroah.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
       arjan@infradead.org, peterz@infradead.org, hch@infradead.org
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808141501.00613.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+z+3Im05BrL6UXfDUyLj2PhgK1xMCgxNo8JlU
 7Jhi0UWoFeztrU0zPr/0HKpt6nQr5jq3jrPqSc91Z89a55UVYX
 v8zca6nvdgXM8ewJt4oPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Alan Cox wrote:
> > So, what is it that anti-malware companies do?  They scan files.  That's
> > it. 
> 
> Good so lets instead have a discussion about making the file event
> notification more scalable. That is the same thing I want for content
> indexing. It is the same thing you want for certain kinds of smart
> archiving, for on-line asynchronous backup and other stuff.
> 
> It ought to be a simple clean syscall interface.

In this case, it seems to be the same kind of requirement that lead to
dnotify and inotify, right?

So in order to get the third notification syscall interface right, the
obvious questions are:

1. How do you make it cleaner than inotify?
2. How do you make it more scalable than inotify?
3. Do you need it to do anything that inotify doesn't do, beyond 1. and 2.?

	Arnd <><
