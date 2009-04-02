Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbZDBSnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbZDBSnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbZDBSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:42:50 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:46578 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761165AbZDBSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:42:49 -0400
Message-ID: <49D5071D.50001@freescale.com>
Date: Thu, 02 Apr 2009 13:42:37 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Marcel Ziswiler <marcel@ziswiler.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] QE USB Host Integration for MPC832x
References: <1238622396-9768-1-git-send-email-marcel@ziswiler.com> <20090402183357.GA29050@oksana.dev.rtsoft.ru> <20090402183631.GA6699@oksana.dev.rtsoft.ru>
In-Reply-To: <20090402183631.GA6699@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:

> Oh, I was wrong. fsl_qe_udc driver uses mpc8360 compatible for
> matching, so you can't remove it. :-/

Ugh, that's a bug in the driver then.

My understanding is that the only MPC8323 QE microcode update is the one
for UART.  If there are any updates to any other QE devices for standard
functionality, I'm not aware of any.

-- 
Timur Tabi
Linux kernel developer at Freescale
