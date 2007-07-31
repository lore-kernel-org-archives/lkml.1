Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbXGaIHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbXGaIHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXGaIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:07:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57850 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbXGaIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:07:15 -0400
Date: Tue, 31 Jul 2007 09:13:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/3] coredump: cleanup documentation for suid_dumpable
Message-ID: <20070731091337.5f3cb923@the-village.bc.nu>
In-Reply-To: <20070731070340.GB2412@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
	<20070731070340.GB2412@kernel.sg>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 15:03:40 +0800
Eugene Teo <eugeneteo@kernel.sg> wrote:

> This patch removes documentation that is related to suidsafe core dump
> mode.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

NAK - this feature is actively used and can be set by the sysctl
interface. The PRCTL fixup was just a bug being fixed. The sysctl
interface is still relevant.


