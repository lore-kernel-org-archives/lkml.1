Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbZFOQJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbZFOQJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbZFOQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:08:55 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58876 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbZFOQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:08:54 -0400
Date: Mon, 15 Jun 2009 12:08:33 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245081420.23207.58.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906151208020.10101@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906121317140.23840@gentwo.org>  <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI> 
 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>  <1245077891.23207.48.camel@penberg-laptop>  <alpine.DEB.1.10.0906151101580.23995@gentwo.org>  <1245078661.23207.50.camel@penberg-laptop>  <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com> 
 <alpine.DEB.1.10.0906151148300.11467@gentwo.org> <1245081420.23207.58.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Pekka Enberg wrote:

> But we still have bit of a problem for should_failslab() and
> __lockdep_trace_alloc(). We might be able to deal with the former by
> adding system_state check but for the latter, we need to mask the gfp
> flags. Hmm.

These issues will appear in multiple places in the core code. Its best to
fix them within these functions.

