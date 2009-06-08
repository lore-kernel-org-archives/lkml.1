Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZFHVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZFHVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZFHVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:23:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbZFHVX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:23:58 -0400
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A2D8011.9050502@linux.vnet.ibm.com>
References: <1244481941.13761.9119.camel@twins>
	 <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop>
	 <4A2D8011.9050502@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 23:23:43 +0200
Message-Id: <1244496223.6691.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 14:18 -0700, Corey Ashford wrote:
> pca.ext_attrs = &feature.head; /* secretly know that there's data that lies past 
> the attr struct header */

Right, except its not so very secret since we have the type field
telling us.

