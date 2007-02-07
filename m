Return-Path: <linux-kernel-owner+w=401wt.eu-S1030612AbXBGJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030612AbXBGJUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030609AbXBGJUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:20:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:53796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030610AbXBGJUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:20:08 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       clameter@engr.sgi.com, akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with memory-less-node
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
	<20070207101400.feda1bf9.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702070002430.2188@schroedinger.engr.sgi.com>
From: Andi Kleen <ak@suse.de>
Date: 07 Feb 2007 11:20:33 +0100
In-Reply-To: <Pine.LNX.4.64.0702070002430.2188@schroedinger.engr.sgi.com>
Message-ID: <p73abzqmfpq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:
> 
> Would it be possible to attach the cpus to the 
> next nodes with memory and mark the node offline? That way we could avoid 
> another mask that we constantly have to check?

That is what x86-64 does and I believe is the right solution to this.

-Andi

