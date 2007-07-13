Return-Path: <linux-kernel-owner+w=401wt.eu-S937018AbXGMTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937018AbXGMTAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbXGMTAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:00:36 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:52962 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbXGMTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:00:35 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/3] UML - Limit request size on COWed devices
References: <20070713143755.GA6244@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: Our Lady of Perpetual Garbage Collection
Date: Fri, 13 Jul 2007 20:00:13 +0100
In-Reply-To: <20070713143755.GA6244@c2.user-mode-linux.org> (Jeff Dike's message of "Fri, 13 Jul 2007 10:37:55 -0400")
Message-ID: <87odigw2ma.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Jul 2007, Jeff Dike uttered the following:

> COWed devices can't handle more than 32 (64 on x86_64) sectors in one
> request due to the size of the bitmap being carried around in the
> io_thread_req.

This feels like a -stable candidate to me.
