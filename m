Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYH2TsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYH2TsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYH2TsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:48:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYH2Tr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:47:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
Date: Fri, 29 Aug 2008 21:47:26 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Serge Hallyn <serue@us.ibm.com>, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>
In-Reply-To: <m163pjr5qf.fsf@frodo.ebiederm.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808292147.27720.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184qrvIQz61rPfvgC0FOWMjZ2RlWsGPhKUQk4u
 BEQmocEnTm05vl9A7QnmPdZsi8wYhqeTJQ25vwOkBdNm/o9xxx
 GoAN44erfsxl/jbXuSOkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Eric W. Biederman wrote:
> However it is a largely an insane idea.

I fully agree.

> Given the pain it is to maintain ioctls I would be very surprised if we wanted
> to open up that pandoras box even wider by allowing arbitrary user space
> processes to support random ioctls.  How would you do 32/64bit support
> and the like?

I think that is not too much of a problem: Just like the file operations in
the kernel have two callbacks (ioctl and compat_ioctl), you need to provide
both operations from user space if there is a difference between them, or
at least a stub otherwise.

	Arnd <><
