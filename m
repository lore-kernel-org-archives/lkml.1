Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZF3BQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZF3BQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZF3BQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:16:05 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:46076 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680AbZF3BQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:16:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z9E5hrWQP0yBiwsMCNP5ZCiNLhfjQxRuNwuD/vY55t6ZVYN1izj8vtMfk01AsFSFCveG6P8Sn6szGLJ7ALGaFFf32tt8oi+ULRPy7P6tfDkSIiH3uhCS8GvoAJ1JUr+5;
Date: Mon, 29 Jun 2009 18:16:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/pci: fix boundary checking when using root CRS
Message-ID: <20090629181603.261ccd03@jbarnes-g45>
In-Reply-To: <4A42DA6F.2030305@kernel.org>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A42DA6F.2030305@kernel.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 19:01:19 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> don't touch info->res_num if we are out of space
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Gary, any comments on these?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
