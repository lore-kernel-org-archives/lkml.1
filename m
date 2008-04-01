Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYDACb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYDACb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYDACbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:31:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:33800 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYDACbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:31:20 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: OOM (HighMem) on linux 2.6.24.2
Date: Tue, 1 Apr 2008 04:31:11 +0200
User-Agent: KMail/1.8.2
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <1205974089.4023.20.camel@kulgan.wumi.org.au> <1206003275.8514.399.camel@twins> <1206007485.5086.8.camel@kulgan.wumi.org.au>
In-Reply-To: <1206007485.5086.8.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010431.11271.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 11:04, Kevin Shanahan wrote:
> Feb 28 06:32:20 hermes kernel: 5313 pages slab
> Feb 28 06:32:20 hermes kernel: 2632 pages pagetables
> Feb 28 06:32:20 hermes kernel: Out of memory: kill process 24013 (apache2) score 22070 or a child
> Feb 28 06:32:20 hermes kernel: Killed process 24013 (apache2)
> 
> Looks like the HighMem low watermark was hit again (though I've no idea
> if that's actually significant).

I kno that people routinely forget to do that, but
at least for purely paranoid reasons you are better
to run all daemons with setrlimit'ed memory size.
At least all daemons which you cannot reasonably
trust to be 100% leak-free and to have bounded
peak memory usage.

This way, only leaking saemon will die (and you will easily see
which one) instead of entire system.
--
vda
