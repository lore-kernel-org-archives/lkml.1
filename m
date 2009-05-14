Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZENUbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZENUbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZENUbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:31:23 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47679 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbZENUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:31:23 -0400
Date: Thu, 14 May 2009 16:31:16 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Rik van Riel <riel@redhat.com>
cc: Robin Holt <holt@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
In-Reply-To: <4A0C7DB6.6010601@redhat.com>
Message-ID: <alpine.DEB.1.10.0905141629440.15881@qirst.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120729.5885.A69D9226@jp.fujitsu.com> <20090513152256.GM7601@sgi.com> <alpine.DEB.1.10.0905141602010.1381@qirst.com> <4A0C7DB6.6010601@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Rik van Riel wrote:

> I suspect that patches 1/4 through 3/4 will cause the
> system to behave better already, by only reclaiming
> the easiest to reclaim pages from zone reclaim and
> falling back after that - or am overlooking something?

zone reclaims default config has always only reclaimed the easiest
reclaimable pages. Manual configuration is necessary to reclaim other
pages.


