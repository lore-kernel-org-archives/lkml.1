Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZHZL2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZHZL2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZHZL2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:28:23 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:48610 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbZHZL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:28:22 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v2 PATCH 2/2]: pseries: Implement Pseries Processor Idle idle
 module.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090826111003.GC29759@linux.vnet.ibm.com>
References: <20090826110721.GA29759@linux.vnet.ibm.com>
	 <20090826111003.GC29759@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:27:18 +0200
Message-Id: <1251286038.1329.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 16:40 +0530, Arun R Bharadwaj wrote:
> +void (*pm_idle)(void);
> +EXPORT_SYMBOL_GPL(pm_idle);

Seriously.. this caused plenty problems over on x86 and you're doing the
exact same dumb thing?

