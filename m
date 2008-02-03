Return-Path: <linux-kernel-owner+w=401wt.eu-S935690AbYBCBjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935690AbYBCBjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbYBCBjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:39:40 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:38328
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764421AbYBCBjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:39:39 -0500
Date: Sun, 3 Feb 2008 02:39:36 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 0/4] [RFC] EMMU Notifiers V5
Message-ID: <20080203013936.GB7185@v2.random>
References: <20080201050439.009441434@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201050439.009441434@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 09:04:39PM -0800, Christoph Lameter wrote:
> - Has page tables to track pages whose refcount was elevated(?) but
>   no reverse maps.

Just a correction, rmaps exists or swap couldn't be sane, it's just
that it's not built on the page_t because the guest memory is really
virtual and not physical at all (hence it swaps really well, thanks to
the regular linux VM algorithms without requiring any KVM knowledge at
all, it all looks (shared) anonymous memory as far as linux is
concerned ;).
