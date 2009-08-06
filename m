Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZHFMZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZHFMZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZHFMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:25:09 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:13931
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbZHFMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:25:08 -0400
X-IronPort-AV: E=Sophos;i="4.43,333,1246831200"; 
   d="scan'208";a="32144226"
Message-ID: <4A7ACBAF.8040305@inria.fr>
Date: Thu, 06 Aug 2009 14:25:19 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Brice Goglin <Brice.Goglin@inria.fr>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD Magny-Cours
References: <20090805154402.GA6520@alberich.amd.com> <4A79EA5A.7040308@inria.fr> <20090806104240.GC7198@alberich.amd.com>
In-Reply-To: <20090806104240.GC7198@alberich.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> Of course I thought also to implement it this way because it looks
> more consistent, but IMHO the patches are less intrusive if this
> scheme is _not_ used. Instead I kept core_siblings as is ("for
> historic reasons", nobody needs to accustom to new semantics). And use
> cpu_node_siblings where it really matters.
>   

Well, core_siblings and cpu_node_sibling will only be different on
Magny-Cours anyway. So even if core_siblings becomes "all cores in
cpu_node" instead of "all cores in socket", it won't actually break any
existing setup. I personally prefer having the same kind of semantics
for all foo_siblings rather than having something with a different
meaning between core and thread.

Brice

