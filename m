Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbXGDVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbXGDVoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbXGDVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:44:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbXGDVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:44:08 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some love to default profiler
References: <20070704213420.GA5864@martell.zuzino.mipt.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Jul 2007 00:39:38 +0200
In-Reply-To: <20070704213420.GA5864@martell.zuzino.mipt.ru>
Message-ID: <p73fy433iad.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> 2) Put profile.c under CONFIG_PROFILING. You enabled profiling in config, you
>    will get it. Removes conditional branch from schedule(). Code savings on my
>    usual config:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	2921871	 179895	 180224	3281990	 321446	vmlinux		before
> 	2920141	 179847	 180224	3280212	 320d54	vmlinux		after
> 	--------------------------------------------------------------
> 	  -1730     -48           -1778

I think it's better to keep it by default. 1.7k is not really all that much.

-Andi
