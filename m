Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYHKOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYHKOWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHKOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:22:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYHKOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:22:28 -0400
Message-ID: <48A04AEE.8090606@linux-foundation.org>
Date: Mon, 11 Aug 2008 09:21:34 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>	 <48A046F5.2000505@linux-foundation.org>	 <1218463774.7813.291.camel@penberg-laptop>	 <48A048FD.30909@linux-foundation.org> <1218464177.7813.293.camel@penberg-laptop>
In-Reply-To: <1218464177.7813.293.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> The function call is supposed to go away when we convert kmemtrace to
> use Mathieu's markers but I suppose even then we have a problem with
> inlining?

The function calls are overwritten with NOPs? Or how does that work?


