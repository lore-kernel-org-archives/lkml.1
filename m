Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYDPNfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYDPNfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYDPNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:35:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYDPNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:35:45 -0400
Date: Wed, 16 Apr 2008 14:35:24 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [2.6 patch] make dm_set_device_limits() static
Message-ID: <20080416133524.GG18935@agk.fab.redhat.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20080330232836.GX28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330232836.GX28445@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 02:28:36AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global dm_set_device_limits() static.
 
Not needlessly global IMHO: It's part of the interface available for dm
targets to use.  For example, dm-loop uses it.  The whole device limits
thing is still problematic anyway, as dynamic changes to the
restrictions aren't propagated, so we need more work in this area.

Alasdair
-- 
agk@redhat.com
