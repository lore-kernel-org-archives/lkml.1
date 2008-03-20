Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYCTOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYCTOjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbYCTOjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:39:12 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:35927 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbYCTOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d+zIVmy8WhuxEc0UnAPvrVxrDK4qR7R2DpjerGIsLdP+pXiT5a3vextYTGFUNv7zIdmw+pgSAdpwerU/w6oXGZcrw1IowTKuT4+1R7aPr7DFONHS46a5AxCkUo+SiRSggJHuR7Ss+bF23/Pt9msLA6DGHE/km3vmx0KDSzTq1wI=
Message-ID: <87a5b0800803200739v6d222afck850f221eae1edd70@mail.gmail.com>
Date: Thu, 20 Mar 2008 14:39:08 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
Cc: "Daniel Drake" <dsd@gentoo.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <1206023695.16475.137.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206023695.16475.137.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 2:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

>  +For some ethernet hardware that cannot DMA to unaligned addresses like
>  +4*n+2 or non-ethernet hardware, this can be a problem, and it is then
>  +required to copy the incoming frame into an aligned buffer. Because this is
>  +unnecessary on architectures that can do unaligned accesses, the code can be
>  +made depend on CONFIG_ARCH_CAN_UNALIGNED_ACCESS like so:
>  +
>  +#ifdef CONFIG_ARCH_CAN_UNALIGNED_ACCESS
>  +       skb = copy skb
>  +#else
>  +       skb = original skb
>  +#endif

Is this logic reversed?
