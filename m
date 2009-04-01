Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbZDABWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbZDABWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZDABVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:21:54 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:5739 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754651AbZDABVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:21:53 -0400
Date: Wed, 01 Apr 2009 10:21:47 +0900 (JST)
Message-Id: <20090401.102147.40646663.nemoto@toshiba-tops.co.jp>
To: lg@denx.de
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH] dmaengine: fix regression introduced by
 d6103085dfd83c13db65c3bd7e182f021d77c541
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.64.0903311755540.4806@axis700.grange>
References: <Pine.LNX.4.64.0903311755540.4806@axis700.grange>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 18:07:34 +0200 (CEST), Guennadi Liakhovetski <lg@denx.de> wrote:
> chan is an index variable, used to loop over a list of channels, and here 
> it is used _after_ the loop, in which case it doesn't point to a DMA 
> channel struct anymore. Dereferencing it leads to a corruption of a random 
> memory location, which in my case was a pointer inside a clock struct. Fix 
> it by using a local variable pointing to the DMA device.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>

Oops!  your fix is correct.  Thank you for fixing this nasty bug.

---
Atsushi Nemoto
