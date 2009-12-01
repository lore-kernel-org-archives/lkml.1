Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZLAKNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZLAKNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZLAKNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:13:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:53955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZLAKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:13:15 -0500
Date: Tue, 1 Dec 2009 02:14:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Message-ID: <20091201021459.43d2142a@infradead.org>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
	<20091126094930.GD32275@elte.hu>
	<8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 16:54:04 +0800
"Ma, Ling" <ling.ma@intel.com> wrote:

> Hi Ingo
> 
> Thanks for your correction, so we use perf stat --repeat 3 to test
> volano, tbench, and kbuild, Because netperf has multiple items we may
> send out later.

a key question is.. how much more memory do you have free due to -Os?
(because memory is cache is performance on a system level as well)
and how much less icache pressure is there?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
