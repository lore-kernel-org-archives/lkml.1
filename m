Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXDSWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXDSWbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXDSWbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:31:04 -0400
Received: from gw.goop.org ([64.81.55.164]:39146 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbXDSWbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:31:01 -0400
Message-ID: <4627ED99.3030201@goop.org>
Date: Thu, 19 Apr 2007 15:30:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@waste.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 20/20] Add apply_to_page_range() which applies a function
 to a pte range.
References: <20070404191151.009821039@goop.org> <20070404191206.675793431@goop.org> <20070405044133.GE4892@waste.org> <46149CC9.2070903@goop.org> <20070417205652.GM11115@waste.org> <4627C6B9.7000605@goop.org> <20070419195957.GF11115@waste.org> <4627E131.5070801@goop.org> <20070419213013.GI11115@waste.org>
In-Reply-To: <20070419213013.GI11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> I was counting from the top down.
>   

Bottom-up is better; that way the levels don't change for 2,3,4 level
pagetables.

    J

