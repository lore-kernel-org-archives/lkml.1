Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYESXGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYESXGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYESXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:06:21 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:53489 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYESXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:06:19 -0400
X-Greylist: delayed 1583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 19:06:19 EDT
Date: Mon, 19 May 2008 18:39:43 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
	logic
Message-ID: <20080519223943.GA8168@cathedrallabs.org>
References: <20080519144557.19326.74313.stgit@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519144557.19326.74313.stgit@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,
> Right now each tty has its own port level structure which means we can share
> no code between ports. Introduce a structure and some initial minor helper
> routines so that we can move towards commonality. In doing this the USB serial
> code gets a bit of shake up as it kept using port->tty unsafely. Fixing that
> means changing the API of all the USB serial drivers. On the bright side the
> API now looks far more like the tty layer API which will become useful later
> on.
do you have your tty/serial rework tree available in some server?

-- 
Aristeu

