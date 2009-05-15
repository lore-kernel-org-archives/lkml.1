Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZEOT6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZEOT6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZEOT6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:58:47 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:57462 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbZEOT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:58:47 -0400
Date: Fri, 15 May 2009 15:29:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242411727.28257.39.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0905151528480.13433@qirst.com>
References: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>  <alpine.DEB.1.10.0905121708470.14226@qirst.com>  <20090514092909.GG1365@ucw.cz>  <alpine.DEB.1.10.0905141546040.1381@qirst.com>  <1242333519.15391.210.camel@nimitz> 
 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>  <1242335120.15391.242.camel@nimitz>  <alpine.DEB.1.10.0905141729180.30187@qirst.com>  <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>  <20090515130547.GA1976@elf.ucw.cz>
  <alpine.DEB.1.10.0905151358430.26559@qirst.com> <1242411727.28257.39.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Dave Hansen wrote:

> Perhaps we should ensure that total RAM mlock()ed + vm_dirty_bytes is
> always under total ram.  That'll force people to either stop mlocking or
> do the safe thing which is drop vm_dirty_bytes.

Guess a global mlock ratio would be good? Set it at a reasonable limit of
10% and tell the user that the system may OOM if set too high.

