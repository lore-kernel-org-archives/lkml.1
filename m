Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbZLHGRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbZLHGRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZLHGRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:17:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:48454 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbZLHGRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:17:45 -0500
Subject: Re: [PATCH v6 0/2] pseries: Add cede support for cpu-offline
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091126195121.29159.66098.stgit@drishya>
References: <20091126195121.29159.66098.stgit@drishya>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 17:14:53 +1100
Message-ID: <1260252893.16132.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these patches (Gautham or Nathan, I haven't bisected) break 
pseries build without CONFIG_SMP. I'll apply them anyways for now
to next and push them out today since nobody ever builds pseries without
CONFIG_SMP but I would appreciate if you could send a fix regardless.

Cheers,
Ben.


