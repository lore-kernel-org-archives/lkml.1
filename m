Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYKGS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYKGS2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKGS2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:28:35 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:46872 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKGS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:28:34 -0500
Date: Fri, 7 Nov 2008 12:28:04 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
In-Reply-To: <20081107054437.GA21421@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811071227330.5387@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
 <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com>
 <20081107162114.2a41c623.sfr@canb.auug.org.au> <20081107054437.GA21421@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Alexey Dobriyan wrote:

> BTW, on alpha I get
>
> mm/cpu_alloc.c:146:1: error: pasting "per_cpu__" and "(" does not give a valid preprocessing token

That is discussed elsewhere. SHIFT_PERCPU_PTR macro is messed up on alpha.

