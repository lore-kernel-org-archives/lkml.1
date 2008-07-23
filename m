Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYGXAHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYGXAHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYGXAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:06:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60723 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753293AbYGXAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:06:55 -0400
Date: Thu, 24 Jul 2008 00:49:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kevin Shanahan <kmshanah@disenchant.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libata timeout, MCE and kernel panic
Message-ID: <20080724004928.226f892a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080723233509.GJ3930@cubit>
References: <20080723233509.GJ3930@cubit>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> recovery was required. It seems the journal recovery combined with the
> md device reconstruction was enough to cause an ata command
> timeout. After that I saw several MCEs and the kernel paniced.

An MCE is amachine check, and indicates the hardware detected a problem.
Given the sequence of heavy I/O, followed by a timeout and the processors
detecting inconsistencies - is your PSU sufficient ?

