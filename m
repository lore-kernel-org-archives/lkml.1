Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYDAE5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYDAE5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 00:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYDAE5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 00:57:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDAE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 00:57:40 -0400
Subject: Re: OOM (HighMem) on linux 2.6.24.2
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, linux-kernel@vger.kernel.org
In-Reply-To: <200804010431.11271.vda.linux@googlemail.com>
References: <1205974089.4023.20.camel@kulgan.wumi.org.au>
	 <1206003275.8514.399.camel@twins>
	 <1206007485.5086.8.camel@kulgan.wumi.org.au>
	 <200804010431.11271.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 06:57:27 +0200
Message-Id: <1207025847.8514.675.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 04:31 +0200, Denys Vlasenko wrote:
> On Thursday 20 March 2008 11:04, Kevin Shanahan wrote:
> > Feb 28 06:32:20 hermes kernel: 5313 pages slab
> > Feb 28 06:32:20 hermes kernel: 2632 pages pagetables
> > Feb 28 06:32:20 hermes kernel: Out of memory: kill process 24013 (apache2) score 22070 or a child
> > Feb 28 06:32:20 hermes kernel: Killed process 24013 (apache2)
> > 
> > Looks like the HighMem low watermark was hit again (though I've no idea
> > if that's actually significant).
> 
> I kno that people routinely forget to do that, but
> at least for purely paranoid reasons you are better
> to run all daemons with setrlimit'ed memory size.
> At least all daemons which you cannot reasonably
> trust to be 100% leak-free and to have bounded
> peak memory usage.

Afaik we don't actually implement RLIMIT_RSS.

