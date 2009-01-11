Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZAKQS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZAKQS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZAKQSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:18:47 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46488 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZAKQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:18:46 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Date: Sun, 11 Jan 2009 17:18:41 +0100
User-Agent: KMail/1.9.9
Cc: "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <200901111518.38880.borntraeger@de.ibm.com> <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
In-Reply-To: <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111718.41756.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 11 Januar 2009 schrieb Jeff Chua:
> > I found a nearby commit during bisect, which looks much saner:
> >
> > http://marc.info/?l=linux-kernel&m=123167815028388&w=2
> 
> This was committed earlier than
> a0e280e0f33f6c859a235fb69a875ed8f3420388, and
> a0e280e0f33f6c859a235fb69a875ed8f3420388 was the last working kernel
> that is able to suspend/resume. Go one before, and suspend/resume
> breaks.

Yes, I am aware that this patch fixes one of the many S2R problems in 
2.6.29-rc. Thats why I had 

commit a0e280e0f33f6c859a235fb69a875ed8f3420388
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Wed Jan 7 16:19:46 2009 +0100

    stop_machine/cpu hotplug: fix disable_nonboot_cpus

as an additional patch applied during my bisect.

Christian
