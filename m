Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbYBNHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbYBNHwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbYBNHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:52:09 -0500
Received: from mail.artecdesign.ee ([62.65.32.9]:39642 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbYBNHwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:52:08 -0500
X-Greylist: delayed 2103 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 02:52:08 EST
Subject: Re: [2.6 patch] make mtd/nand/cs553x_nand.c:part_probes[] static
From: Mart Raudsepp <mart.raudsepp@artecdesign.ee>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213213010.GX3383@cs181133002.pp.htv.fi>
References: <20080213213010.GX3383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Feb 2008 09:16:47 +0200
Message-Id: <1202973407.4560.3.camel@martr-gentoo.artec>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8BIT
X-ADG-Spam-Score: -5.9 (-----)
X-ADG-Spam-ScoreInt: -58
X-ADG-Spam-Report: Content analysis details:   (-5.9 points, 5.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: 1e0d58aac167f38cfdbb485f54453400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ühel kenal päeval, K, 2008-02-13 kell 23:30, kirjutas Adrian Bunk:
> This patch makes the needlessly global part_probes[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Mart Raudsepp <mart.raudsepp@artecdesign.ee>

Note that many other drivers in mtd/nand have the same part_probes array
global instead of static.


