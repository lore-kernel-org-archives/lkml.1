Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbZFOPse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbZFOPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZFOPs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:48:27 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51854 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbZFOPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:48:26 -0400
Date: Mon, 15 Jun 2009 11:48:07 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245078661.23207.50.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906151147200.11467@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906121317140.23840@gentwo.org>  <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI> 
 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>  <1245077891.23207.48.camel@penberg-laptop>  <alpine.DEB.1.10.0906151101580.23995@gentwo.org> <1245078661.23207.50.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Pekka Enberg wrote:

> The point here is that the actual debugging hooks do a whole lot more
> than cacheline load + alu op even in the "fastpath" case (if such a
> thing exists for those).

Then it is best to confine additional boot time checking to
those debugging function.

