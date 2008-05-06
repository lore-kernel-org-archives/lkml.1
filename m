Return-Path: <linux-kernel-owner+w=401wt.eu-S1764709AbYEFPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764709AbYEFPZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbYEFPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:25:00 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:42291 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbYEFPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:24:59 -0400
Date: Tue, 6 May 2008 11:24:58 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: parisc DISCONTIGMEM compile breakage
Message-ID: <20080506152457.GA13070@phobos.i.cabal.ca>
References: <20080506134648.GA30082@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506134648.GA30082@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 04:46:48PM +0300, Adrian Bunk wrote:
> Commit 54a6eb5c4765aa573a030ceeba2c14e3d2ea5706
> (mm: use two zonelist that are filtered by GFP mask)
> causes the following build error with CONFIG_DISCONTIGMEM=y
> on parisc:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/parisc/mm/init.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/parisc/mm/init.c: In function 'show_mem':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/parisc/mm/init.c:609: error: too few arguments to function 'node_zonelist'
> make[2]: *** [arch/parisc/mm/init.o] Error 1
> 

yes. the obvious fix works and boots, but I haven't quite determined why
they decided to add this yet, so no patch committed plz.

cheers, kyle
