Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYBRPLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYBRPLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYBRPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:11:09 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:32196 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbYBRPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:11:07 -0500
Message-ID: <47B99FF8.8030900@trash.net>
Date: Mon, 18 Feb 2008 16:10:48 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] remove include/linux/netfilter_ipv4/ipt_SAME.h
References: <20080217083031.GY3848@cs181133002.pp.htv.fi>
In-Reply-To: <20080217083031.GY3848@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch removes the no longer used include/linux/netfilter_ipv4/ipt_SAME.h


We kept it around because old iptables binaries need it to build.
The kernel no longer supports it, but people might still wish to
use a distributor-built iptables binary with old kernels. It will
be removed with a number of other headers kept for compatibility
in 1-2 years.

