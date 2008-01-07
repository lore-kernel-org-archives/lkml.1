Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYAGBZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYAGBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYAGBZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:25:49 -0500
Received: from ozlabs.org ([203.10.76.45]:49313 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYAGBZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:25:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 2/2] track and print last unloaded module in the oops trace
Date: Mon, 7 Jan 2008 12:25:37 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, ak@suse.de, mingo@elte.hu
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
In-Reply-To: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071225.37707.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 10:19:46 Arjan van de Ven wrote:
> Subject: track and print last unloaded module in the oops trace
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: rusty@rustcorp.com.au
> CC: ak@suse.de
> CC: mingo@elte.hu
>
> Based on a suggestion from Andi:
> In various cases, the unload of a module may leave some bad state around
> that causes a kernel crash AFTER a module is unloaded; and it's then hard
> to find which module caused that.
>
> This patch tracks the last unloaded module, and prints this as part of the
> module list in the oops trace.
>
> Right now, only the last 1 module is tracked; I expect that this is enough
> for the vast majority of cases where this information matters; if it turns
> out that tracking more is important, we can always extend it to that.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks, applied.

Rusty.
