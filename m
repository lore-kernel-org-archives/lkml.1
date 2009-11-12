Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZKLRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZKLRIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZKLRIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:08:43 -0500
Received: from lo.gmane.org ([80.91.229.12]:51777 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZKLRIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:08:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Date: Thu, 12 Nov 2009 17:07:32 +0000
Message-ID: <kvrts6-7b4.ln1@chipmunk.wormnet.eu>
References: <200911112134.34261.bzolnier@gmail.com> <4AFB2298.5040903@nortel.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen <cfriesen@nortel.com> wrote:
>> 
>> "ht" flag indicates only ability to detect siblings not HT presence itself.
>> 
>> Inspired by:
>> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
>> 
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> ---
>> It could be that there are some user-space programs depending on "ht"
>> flag so the patch is marked as RFC..
> 
> If a cpu is capable of ht but doesn't have any siblings, do we actually
> care?
> 
I have a Core2 Duo U7600 with siblings set to 2 and the 'ht' flag and I 
know the CPU in my lapdog does not actually support hyperthreading.

> If many people consider the "ht" flag to indicate that hyperthreading is
> actually available, what about instead changing the meaning of the "ht"
> flag to indicate that there actually are siblings?
> 
Could be determined surely by "grep siblings /proc/cpuinfo"?

Cheers

-- 
Alexander Clouter
.sigmonster says: Old musicians never die, they just decompose.

