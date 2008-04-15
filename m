Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYDOHES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYDOHES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYDOHEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:04:07 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:4554 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYDOHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3SlIXf+RXgubjLQ2GFU+yOQuurpkculB4hb+MVjBhE/t8QXa7APi7Q9nuhyEqqu1EAbCGNpAUOnXfg7y+I1KEXwXu67Ch+KHc0LcXMDCki5ZOG2RpTJtMp/la43ZxLIe1Snp34kiaV9eSagfIVilkbvV0B1puv1j/GFUSDn8tA=
Message-ID: <86802c440804150004w1c94b2dci520e0ffb8b60632f@mail.gmail.com>
Date: Tue, 15 Apr 2008 00:04:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080414232308.ffa4e269.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.704752615@symbol.fehenstaub.lan>
	 <87lk3hwv52.fsf@basil.nowhere.org>
	 <20080414232308.ffa4e269.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
>  > Johannes Weiner <hannes@saeurebad.de> writes:
>  >
>  > > Make free_bootmem() look up the node holding the specified address
>  > > range which lets it work transparently on single-node and multi-node
>  > > configurations.
>  >
>  > Acked-by: Andi Kleen <andi@firstfloor.org>
>  >
>  > This is far better than the original change it replaces and which
>  > I also objected to in review.
>  >
>
>  So...  do we think these two patches are sufficiently safe and important for
>  2.6.25?

the patch is wrong

YH
