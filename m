Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZELQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZELQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZELQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:16:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755300AbZELQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:16:08 -0400
Date: Tue, 12 May 2009 11:16:05 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512161605.GB19747@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 08:10:18AM -0700, Yinghai Lu wrote:
> jack,
> 
> can you confirm:
> 1. without this patch, your system still have problem?
> 2. does current tip/master work for you?

The current tip/master fails with or without the patch. AFAICT, the
failure is identical in both cases.

--- jack
