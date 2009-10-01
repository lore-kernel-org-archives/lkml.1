Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZJAUv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZJAUv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZJAUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:51:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZJAUv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:51:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [PATCH 1/2] Move swap functions 
 =?iso-8859-1?q?to=09kernel/power/swap=2Ec=2E?=
Date: Thu, 1 Oct 2009 22:53:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4AC036F9.5000003@crca.org.au> <200909292224.32795.rjw@sisk.pl> <4AC405BE.7070304@crca.org.au>
In-Reply-To: <4AC405BE.7070304@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910012253.24465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 October 2009, Nigel Cunningham wrote:
> Hi.
> 
> Rafael J. Wysocki wrote:
> > On Monday 28 September 2009, Nigel Cunningham wrote:
> >> Move hibernation code's functions for allocating and freeing swap
> >> from swsusp.c to swap.c, which is where you'd expect to find them.
> > 
> > Sorry for the delay.
> > 
> > Both patches look good, I'm going to add them to suspend-2.6/linux-next
> > in the next few days.
> 
> Okay; thanks.
> 
> I have another patch for allocating the swap prior to starting to write 
> the image (working towards removing the index pages and then adding 
> readahead & compression). I know the preallocation patch works, but want 
> to do a little more testing (make sure it's always calculating correctly 
> how many pages are needed) before I send it.

Fine by me.

Thanks,
Rafael
