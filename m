Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZJGO1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZJGO1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbZJGO1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:27:00 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:7419 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228AbZJGO1A convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 7 Oct 2009 10:27:00 -0400
Message-Id: <4ACCC12E020000780001882B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 07 Oct 2009 15:26:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: <linux-mm@kvack.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc()
	 invocation  (v2)
References: <4ACCA98202000078000187DF@vpn.id2.novell.com>
 <Pine.LNX.4.64.0910071451090.4695@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910071451090.4695@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hugh Dickins <hugh.dickins@tiscali.co.uk> 07.10.09 15:55 >>>
>On Wed, 7 Oct 2009, Jan Beulich wrote:
>
>> - avoid wasting more precious resources (DMA or DMA32 pools), when
>>   being called through vmalloc_32{,_user}()
>> - explicitly allow using high memory here even if the outer allocation
>>   request doesn't allow it, unless is collides with __GFP_ZERO
>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                            that's no longer an issue in the patch

Oops. Will send out a corrected version in a second.

Jan

