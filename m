Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZKRGGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZKRGGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZKRGGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:06:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:47978 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZKRGGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:06:03 -0500
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
 without CONFIG_XICS set
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:05:32 +1100
Message-ID: <1258524332.2140.663.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> KConfig doesn't require CONFIG_XICS to be set with CONFIG_PSERIES but if
> it's not set, there are numerous small build errors. This is a small series
> of patches to allow CONFIG_XICS to be unset in the config.
> 
> XICS appears to be some sort of interrupt controller but I'm not sure how
> common it is on systems that require CONFIG_PSERIES. If CONFIG_PSERIES
> universally requires CONFIG_XICS, the better path might be to force it to
> be set.
> 
> Testing was building with make oldconfig a configuration from 2.6.31 on
> a PPC970.

CONFIG_XICS should be made invisible and selected by PSERIES.

Cheers,
Ben.


