Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYHRObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYHRObU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYHRObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:31:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:6251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYHRObG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=N23myWlPTiRn2zHjyAoeSgY9LDv3DOt+ZdK2Sal5yX07sQWFq9UeWnA/GahYm9R2Sh
         IiFLR30DZ4y6ZHZaQGhCqO3MELFKtViuaP8JgdpzKZauFdlqgSg8e29NXGFQzLAuLiKN
         XqSbeFhuqPDnt3fbTcihg71i/B+bx60/4cLbY=
Message-ID: <2c0942db0808180731k7423df7ct75e3a27d404764d0@mail.gmail.com>
Date: Mon, 18 Aug 2008 07:31:05 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       "David Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48A98228.9090006@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A086B6.2000901@linux-foundation.org>
	 <20080811.141501.01468546.davem@davemloft.net>
	 <Pine.LNX.4.64.0808121058550.4551@wrl-59.cs.helsinki.fi>
	 <1219025114.25933.6.camel@ymzhang>
	 <48A98228.9090006@linux-foundation.org>
X-Google-Sender-Auth: 950c266a8476dfc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 7:07 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Zhang, Yanmin wrote:
>
>> Other regressions on other machines are similar.
>
> There are AIM7 regressions that are similar to tbench.
>
> 2.6.22  28436
> 2.6.26  23064

Just a shot in the dark -- is this with Group Scheduling on or off?
Off is prefered for benchmarks.
