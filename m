Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbXHDREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbXHDREt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbXHDREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:04:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63966 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXHDREj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=nef7GlHSeksYxPpBdygwUIbstPgqOMBcxJZ9UY/TdgMCIDW8QAPtia+shu2U1N5vyAPKqDE+Fvr0ESPft39sdzhtbcKBp9gzoFW+lhDYQnvxJeyFkA3aNxpXV4THWqb6yrUtnEIqFa2eWpP14klkhBgSV41O8bLGny57MPzHe9g=
Date: Sat, 4 Aug 2007 19:02:10 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070804190210.8b1530dd.diegocg@gmail.com>
In-Reply-To: <20070804163733.GA31001@elte.hu>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 4 Aug 2007 18:37:33 +0200, Ingo Molnar <mingo@elte.hu> escribió:

> thousands of applications. So for most file workloads we give Windows a 
> 20%-30% performance edge, for almost nothing. (for RAM-starved kernel 
> builds the performance difference between atime and noatime+nodiratime 
> setups is more on the order of 40%)

Just curious - do you have numbers with relatime?
