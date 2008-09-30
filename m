Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYI3UyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYI3UyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYI3UyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:54:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYI3UyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:54:13 -0400
Message-ID: <48E291C8.5090405@zytor.com>
Date: Tue, 30 Sep 2008 13:53:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for	GART
References: <20080927181855.GA11147@elte.hu> <20080928193436.GA8386@amd.com> <20080929085647.GB2190@elte.hu> <20080929231116Q.fujita.tomonori@lab.ntt.co.jp> <20080930110319.GA12529@elte.hu>
In-Reply-To: <20080930110319.GA12529@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> all i'm suggesting is to please expose existing debug capabilities in 
> the .config space, so that it can be tested in automated setups.
> 

Boot configurations, too, can be tested in automated setups, and there 
is benefit to being able to do that without compilation.  However, what 
we'd need is a machine-readable description that one can select a 
configuration from.

	-hpa
