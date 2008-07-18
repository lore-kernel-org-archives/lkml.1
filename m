Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYGRPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYGRPVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYGRPV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:21:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38228 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbYGRPV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:21:26 -0400
Message-Id: <4880D12B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 16:21:47 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] i386: reduce boot fixmap space
References: <4880A8AC.76E4.0078.0@novell.com> <4880AD2D.3050407@goop.org>
In-Reply-To: <4880AD2D.3050407@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 18.07.08 16:48 >>>
>Jan Beulich wrote:
>> As 256 entries are needed, aligning to a 256-entry boundary is
>> sufficient and still guarantees the single pte table requirement.
>>   
>
>I unified 32 and 64-bit early_ioremap by making 64-bit use the 32-bit 
>early_ioremap.  In the process I put a similar entry in fixmap_64.h.  
>Would you mind looking to see if the same change is relevant there?

I'm sure it would be applicable there, too, but checking my just refreshed
x86.git snapshot doesn't show anything like that in fixmap_64.h.

Jan

