Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXBST5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXBST5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXBST5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:57:08 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:46599 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504AbXBST5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:57:06 -0500
Date: Mon, 19 Feb 2007 14:57:04 -0500
To: Roland Dreier <rdreier@cisco.com>
Cc: takada <takada@mbf.nifty.com>, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
Message-ID: <20070219195704.GT7582@csclub.uwaterloo.ca>
References: <20070216222728.GF7585@csclub.uwaterloo.ca> <20070216224824.GG7585@csclub.uwaterloo.ca> <20070217000019.GH7582@csclub.uwaterloo.ca> <20070217.231113.193678444.takada@mbf.nifty.com> <20070219145514.GO7582@csclub.uwaterloo.ca> <ada3b5253p0.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3b5253p0.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 11:48:27AM -0800, Roland Dreier wrote:
>  > Does anyone know if there is any way to flush a cache line of the cpu to
>  > force rereading system memory for a given address or address range?
> 
> There is the "clflush" instruction, but not all x86 CPUs support it.
> You need to check the CPUID flag to know for sure (/proc/cpuinfo will
> show a "clflush" flag if it is supported).

Well I will check for that.  Of course it is still possible that is it
actually the network chip screwing up somehow.

--
Len Sorensen
