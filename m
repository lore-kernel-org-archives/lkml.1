Return-Path: <linux-kernel-owner+w=401wt.eu-S934280AbZFLNth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbZFLNth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764881AbZFLNmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:42:45 -0400
Received: from mga10.intel.com ([192.55.52.92]:2862 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933631AbZFLNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,209,1243839600"; 
   d="scan'208";a="698802081"
Date: Fri, 12 Jun 2009 21:26:10 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip] perf_counter/x86: Add a quirk for Atom processors
Message-ID: <20090612132610.GA8634@ywang-moblin2.bj.intel.com>
References: <20090612080855.GA2286@ywang-moblin2.bj.intel.com> <20090612114948.GD16044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612114948.GD16044@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 01:49:48PM +0200, Ingo Molnar wrote:
> 
> * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > The fixed-function performance counters do not work on current 
> > Atom processors. Use the general-purpose ones instead.
> 
> ah, nice - applied to tip:perfcounters/core, thanks!
> 
> Does this make your Atom testbox work fine now?
> 

Yup, I tested the patch before I submitted it. It works fine now;-)
I will also keep an eye on future Atom processors to see whether fixed
function PMCs work or not.

Thanks
-Yong
