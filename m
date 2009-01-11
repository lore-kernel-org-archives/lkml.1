Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbZAKD7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbZAKD7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZAKD6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:58:41 -0500
Received: from sh.osrg.net ([192.16.179.4]:40401 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZAKD6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:58:40 -0500
Date: Sun, 11 Jan 2009 12:58:03 +0900
To: Ian.Campbell@citrix.com
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, jj@chaosbits.net, weiyi.huang@gmail.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 2/2] swiotlb: do not use sg_virt()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1231525930-14087-3-git-send-email-Ian.Campbell@citrix.com>
References: <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
	<1231525930-14087-2-git-send-email-Ian.Campbell@citrix.com>
	<1231525930-14087-3-git-send-email-Ian.Campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090111125753K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jan 2009 18:32:10 +0000
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> Scatterlists containing HighMem pages do not have a useful virtual
> address. Use the physical address instead.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  lib/swiotlb.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)

Looks good.
