Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbXGaIJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbXGaIJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXGaIJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:09:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57859 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbXGaIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:09:09 -0400
Date: Tue, 31 Jul 2007 09:15:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 3/3] coredump: re-implement suid_dumpable using a flag
Message-ID: <20070731091547.388f654c@the-village.bc.nu>
In-Reply-To: <20070731070538.GD2412@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
	<20070731070538.GD2412@kernel.sg>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 15:05:38 +0800
Eugene Teo <eugeneteo@kernel.sg> wrote:

> Hidehiro-san re-implemented suid_dumpable using a pair of bit flags. But
> since we no longer permitting users to call prctl(PR_SET_DUMPABLE, 2),
> there is no need to waste a bit of mm_struct.flags for something that will
> never be used.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

NAK. This is dependant upon removing a feature in use by end users today.
