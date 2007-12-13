Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbXLMXyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbXLMXyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761642AbXLMXyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:54:35 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:54203 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999AbXLMXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:54:34 -0500
Date: Thu, 13 Dec 2007 18:54:32 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071213235432.GA26669@fattire.cabal.ca>
References: <20071213222044.GH21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213222044.GH21616@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:20:44PM +0100, Adrian Bunk wrote:
> Is there anywhere in the kernel a case where __read_mostly brings a 
> measurable improvement or can it be removed?
> 

Yes, definitely[1]... the problem is, and this is also true of other
annotations[2], that people go absolutely nuts adding these annotations
without doing any profiling to see whether they actually improve things.

I'd bet, in the __read_mostly case at least, that there's no
improvement in almost all cases.

cheers, Kyle

1. It's hugely relevant on big-SMP machines.
2. I mean __read_mostly, likely, unlikely, etc., not the useful sparse
annotations.
