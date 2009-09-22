Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZIVEHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZIVEHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZIVEHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:07:33 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57804 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZIVEHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:07:33 -0400
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com
Subject: Re: [2.6.31] Memory leak in load_module()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
	<200909221200.22743.rusty@rustcorp.com.au>
In-Reply-To: <200909221200.22743.rusty@rustcorp.com.au>
Message-Id: <200909221307.CDI12375.QMOFJOSVtHFLFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 22 Sep 2009 13:07:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Fri, 11 Sep 2009 05:08:46 pm Tetsuo Handa wrote:
> > Is this real memory leak?
> 
> Yep.
> 
> God, this code is a turd.  This should fix it though:

Yes. This patch solved the memory leak.

Thank you.
