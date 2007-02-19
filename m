Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbXBSTsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbXBSTsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbXBSTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:48:32 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39032 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbXBSTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:48:30 -0500
X-IronPort-AV: i="4.14,191,1170662400"; 
   d="scan'208"; a="390804692:sNHT43791588"
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: takada <takada@mbf.nifty.com>, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
X-Message-Flag: Warning: May contain useful information
References: <20070216222728.GF7585@csclub.uwaterloo.ca>
	<20070216224824.GG7585@csclub.uwaterloo.ca>
	<20070217000019.GH7582@csclub.uwaterloo.ca>
	<20070217.231113.193678444.takada@mbf.nifty.com>
	<20070219145514.GO7582@csclub.uwaterloo.ca>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Feb 2007 11:48:27 -0800
In-Reply-To: <20070219145514.GO7582@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Mon, 19 Feb 2007 09:55:14 -0500")
Message-ID: <ada3b5253p0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Feb 2007 19:48:27.0856 (UTC) FILETIME=[ECB91500:01C7545E]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Does anyone know if there is any way to flush a cache line of the cpu to
 > force rereading system memory for a given address or address range?

There is the "clflush" instruction, but not all x86 CPUs support it.
You need to check the CPUID flag to know for sure (/proc/cpuinfo will
show a "clflush" flag if it is supported).
