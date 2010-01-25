Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591Ab0AYO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0AYO1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428Ab0AYO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:27:45 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28646
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753346Ab0AYO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:27:44 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dN936eM62a3Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWT45L-02-1PE-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 15:27:21 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, oprofile-list@lists.sf.net
Subject: Re: [PATCH] Add Xeon 7500 series support to oprofile
Message-ID: <20100125142721.GG2014@erda.amd.com>
References: <20100121222627.GA22897@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100121222627.GA22897@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2010 14:27:22.0214 (UTC) FILETIME=[81EBA860:01CA9DCA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.01.10 23:26:27, Andi Kleen wrote:
> Add Xeon 7500 series support to oprofile
> 
> Straight forward: it's the same as Core i7, so just detect
> the model number. No user space changes needed.
> 
> Very simple patch, so it could be still merged for .33?

Patch applied to oprofile/urgent. I will try to merge it for .33.

I would like to see a follow on patch that changes all x86_model
values to hex that have the extended model bit set. This would make
the code more readable since the spec is also using bit values for
this.

Thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

