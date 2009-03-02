Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbZCBIJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbZCBIJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZCBIJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:09:09 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46581 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbZCBIJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:09:08 -0500
Subject: Re: [patch 1/2] slqb: fix deadlock
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090302064735.GA1257@wotan.suse.de>
References: <20090302064735.GA1257@wotan.suse.de>
Date: Mon, 02 Mar 2009 10:09:05 +0200
Message-Id: <1235981345.18284.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 07:47 +0100, Nick Piggin wrote:
> Fix the lockdep error reported by Fengguang where down_read slqb_lock
> is taken twice when reading /proc/slabinfo, with the possibility for a
> deadlock.
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Applied, thanks!

