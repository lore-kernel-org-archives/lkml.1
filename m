Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYJ3Vva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYJ3Vva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759278AbYJ3VvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:51:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbYJ3VvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:51:21 -0400
Message-ID: <490A2C3D.4020202@zytor.com>
Date: Thu, 30 Oct 2008 14:50:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: next-20081030: voyager compile busted
References: <20081030173030.d8847df6.sfr@canb.auug.org.au>	 <20081030180323.GA13399@x200.localdomain>	 <1225398287.19324.1.camel@localhost.localdomain>	 <20081030205230.GO27407@elte.hu>	 <1225400283.19324.6.camel@localhost.localdomain>	 <20081030210704.GA25665@elte.hu>	 <1225401708.19324.35.camel@localhost.localdomain>	 <490A2A30.5040905@zytor.com> <1225403266.19324.42.camel@localhost.localdomain>
In-Reply-To: <1225403266.19324.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> Yes ... been having IRC conversations about that.  We'd need to use
> runtime patching to fix the performance regressions virtualisation has
> been causing us first ... but then we could use it for voyager.
> 

I thought we already were, at least to some degree (the call sites are
way too big and way bigger than they need to be, so we end up with a lot
of NOPs.  I proposed a solution to Jeremy at Kernel Summit, but he
basically said "I don't want to maintain that, I don't care about
hardware performance", which is understandable but highly unfortunate.)

	-hpa
