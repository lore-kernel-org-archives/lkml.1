Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbXJBLYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbXJBLYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJBLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:23:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45936 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXJBLXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:23:23 -0400
Date: Tue, 2 Oct 2007 13:23:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Giuliano Gagliardi <gogi-k@gogi.tv>
cc: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
In-Reply-To: <200710021256.08469.gogi-k@gogi.tv>
Message-ID: <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr>
References: <200710021256.08469.gogi-k@gogi.tv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2 2007 12:56, Giuliano Gagliardi wrote:
>
>I have a server that has to switch to different user ids, but because it does 
>other complex things, I would rather not have it run as root. I only need the 
>server to be able to switch to certain pre-defined user ids.

All you need is CAP_SETUID. Also see man setresuid,
where you could, I think, use saved_uid=0 if you do not
like to use real_uid=0 effective_uid=non-0.


