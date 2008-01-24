Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYAXOmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYAXOmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYAXOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:41:53 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:38051
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYAXOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:41:53 -0500
Date: Thu, 24 Jan 2008 15:41:51 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
Message-ID: <20080124144150.GO7141@v2.random>
References: <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com> <20080123114136.GE15848@v2.random> <Pine.LNX.4.64.0801231149150.13547@schroedinger.engr.sgi.com> <20080124143454.GN7141@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124143454.GN7141@v2.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 03:34:54PM +0100, Andrea Arcangeli wrote:
> set_page_dirty can be called inside ->invalidate_page if needed. But
> I'm not against artificially setting the dirty bit of the pteval
> returned by set_page_dirty, perhaps that's more efficient as it will
              ^^^^^^^^^^^^^^ ptep_clear_flush of course

> require a single locked op on the page_t.
