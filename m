Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXEWVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXEWVv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXEWVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:51:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXEWVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:51:16 -0400
Message-ID: <4654B73C.1030005@zytor.com>
Date: Wed, 23 May 2007 14:50:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christian Volkmann <haveaniceday@cv-sv.de>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
References: <464B9D2C.7040704@cv-sv.de> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <200705191354.06763.ak@suse.de>
In-Reply-To: <200705191354.06763.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>
>> your patch did not work. See the correction below. The mask should contain
>> 1<<1 instead of 1.
>> Model 10 is now also included.
> 
> Ok thanks fixed.
> 

For newsetup, did we agree to just go with model >= 6 or (model >= 6 &&
model <= 10)?  Note that newsetup only does the MSR writes if the flags
are missing, so my inclination is to leave out model <= 10.

	-hpa
