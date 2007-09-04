Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXIDJf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXIDJf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXIDJfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:35:18 -0400
Received: from 83-216-141-215.markhi700.adsl.metronet.co.uk ([83.216.141.215]:3095
	"EHLO mx.hindley.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXIDJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:35:16 -0400
Date: Tue, 4 Sep 2007 10:35:10 +0100
From: Mark Hindley <mark@hindley.org.uk>
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev Mailing List <netdev@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 1/2] 3c59x: Fix uninitialized variable bug
Message-ID: <20070904093510.GL5944@hindley.org.uk>
References: <alpine.LFD.0.999.0709040340250.8504@enigma.security.iitk.ac.in> <20070904081602.GB4241@newton.mathematik.tu-chemnitz.de> <20070904085331.GH5944@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 11:17:57AM +0200, Steffen Klassert wrote:
 
> The only warning that I was able to trigger with gcc 4.2 is in the case of a .config
> without PCI support. In this case I get
> 
> drivers/net/3c59x.c: In function 'vortex_up':
> drivers/net/3c59x.c:1672: warning: 'err' is used uninitialized in this function

That should be fixed by Satyam's patch too.

Mark
