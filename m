Return-Path: <linux-kernel-owner+w=401wt.eu-S1945996AbXBPQxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945996AbXBPQxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXBPQxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:53:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:13187 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945996AbXBPQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:53:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ki/ESnYpSULsgzivHOkRpyTsz0FVs38XOEBRizDyoUy1Az5FtHSl7G7bN3CQE3T4G8q2yKx0X35KNPsyH3EcCgXg6IuRa5tUvs7KwOTUuNEtFdZbIhxAix5Jr3Cs6gXE4Tc8TcQi92RpgDlXFcluMIkdqCFuSnuMhYPrmI5w6KY=
Message-ID: <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com>
Date: Fri, 16 Feb 2007 08:53:30 -0800
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 05/11] syslets: core code
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070216160525.GA21160@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070215133550.GA29274@2ka.mipt.ru>
	 <20070215163704.GA32609@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
	 <20070215181059.GC20997@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
	 <20070215190413.GA23953@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
	 <20070216085706.GA22868@2ka.mipt.ru>
	 <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org>
	 <20070216160525.GA21160@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> if its design is good, then
> interface can be changed in a moment without any problem

This isn't always the case. Sometimes the interface puts requirements
(contract-like) upon the implementation. Case in point in the kernel,
dnotify versus inotify. dnotify is a steaming pile of worthlessness,
because it's userspace interface is so bad (meaning inefficient) as to
be nearly unusable.

inotify has a different interface, one that supplies details about
events rather that mere notice that an event occurred, and therefore
has different requirements in implementation. dnotify probably was a
good design, but for a worthless interface.

The interface isn't always important, but it's certainly something
that has to be understood before putting the finishing touches on the
behind-the-scenes implementation.

Ray
