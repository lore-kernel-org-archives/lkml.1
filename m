Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYFIXSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYFIXSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYFIXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:18:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56458 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753263AbYFIXSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:18:35 -0400
Date: Mon, 9 Jun 2008 16:18:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
In-Reply-To: <484691CB.6090809@goop.org>
Message-ID: <Pine.LNX.4.64.0806091617390.9534@schroedinger.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
 <20080604003019.509483000@polaris-admin.engr.sgi.com> <484691CB.6090809@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Jeremy Fitzhardinge wrote:

> > 	%gs:[&per_cpu_xxxx - __per_cpu_start]
> >   
> 
> Unfortunately that doesn't actually work, because you can't have a reloc with
> two variables.

That is just a conceptual discussion. __per_cpu_start is 0 with the zero 
based patch. And thus this reduces to

%gs[&per_cpu_xxx]

