Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYCQOE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYCQOE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 10:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYCQOEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 10:04:49 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:55922 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYCQOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:04:48 -0400
Message-ID: <47DE786A.7060301@trash.net>
Date: Mon, 17 Mar 2008 14:55:54 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Daniel Hokka Zakrisson <daniel@hozac.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       akpm@linux-foundation.org, skennedy@vcn.com
Subject: Re: [PATCH] netfilter: ipt_recent: sanity check hit count
References: <50136.192.168.101.12.1205588993.squirrel@intranet>
In-Reply-To: <50136.192.168.101.12.1205588993.squirrel@intranet>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hokka Zakrisson wrote:
> If a rule using ipt_recent is created with a hit count greater than
> ip_pkt_list_tot, the rule will never match as it cannot keep track
> of enough timestamps. This patch makes ipt_recent refuse to create such
> rules.


Applied, thanks.
