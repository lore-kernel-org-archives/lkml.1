Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZJAB2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZJAB2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZJAB2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:28:30 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60592 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZJAB23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:28:29 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AC405BE.7070304@crca.org.au>
Date: Thu, 01 Oct 2009 11:28:30 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH 1/2] Move swap functions to	kernel/power/swap.c.
References: <4AC036F9.5000003@crca.org.au> <200909292224.32795.rjw@sisk.pl>
In-Reply-To: <200909292224.32795.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Rafael J. Wysocki wrote:
> On Monday 28 September 2009, Nigel Cunningham wrote:
>> Move hibernation code's functions for allocating and freeing swap
>> from swsusp.c to swap.c, which is where you'd expect to find them.
> 
> Sorry for the delay.
> 
> Both patches look good, I'm going to add them to suspend-2.6/linux-next
> in the next few days.

Okay; thanks.

I have another patch for allocating the swap prior to starting to write 
the image (working towards removing the index pages and then adding 
readahead & compression). I know the preallocation patch works, but want 
to do a little more testing (make sure it's always calculating correctly 
how many pages are needed) before I send it.

Regards,

Nigel
