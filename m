Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZCPPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZCPPiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZCPPiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:38:03 -0400
Received: from mga10.intel.com ([192.55.52.92]:57937 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbZCPPiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:38:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,373,1233561600"; 
   d="scan'208";a="673310131"
Message-ID: <49BE724B.80902@linux.intel.com>
Date: Mon, 16 Mar 2009 08:37:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: linux-next - request_module_nowait() breaks iptables and iwl3945
References: <3823.1237168684@turing-police.cc.vt.edu>
In-Reply-To: <3823.1237168684@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On recent linux-next, iptables and iwl3945 would fail to load
> 
> Bisected down to this commit:
> 

this is ... curious. I just looked at the patch again and it really
looks like it really does not impact the existing codepaths...

do you have any more diagnostics other than "they do not work" ?
