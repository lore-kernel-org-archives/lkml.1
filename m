Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbZDCMub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbZDCMub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZDCMuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:50:22 -0400
Received: from viefep33-int.chello.at ([62.179.121.51]:22749 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbZDCMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:50:21 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402091319.493101305@chello.nl>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 14:50:23 +0200
Message-Id: <1238763023.798.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 11:12 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf_counter_callchain_context.patch)
> Put in counts to tell which ips belong to what context.
> 
>   -----
>    | |  hv
>    | --
> nr | |  kernel
>    | --
>    | |  user
>   -----

Right, just realized that PERF_RECORD_IP needs something similar if one
if not able to derive the context from the IP itself..



