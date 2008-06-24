Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYFXAJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYFXAJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYFXAI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:08:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbYFXAI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:08:56 -0400
Date: Mon, 23 Jun 2008 17:08:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dilinger@queued.net, drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-Id: <20080623170850.6b289569.akpm@linux-foundation.org>
In-Reply-To: <20080623170449.6567d857.akpm@linux-foundation.org>
References: <20080623101352.3bbaf5b0@xo-debian>
	<20080623170449.6567d857.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 17:04:49 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> And it will cause conflicts with overlapping changes in linux-next.


oops, I lied.  The problem was that it secretly depended upon
olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch

So if we want to fix thsi issue in 2.6.26 we need to merge both

olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch

and

olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch

yes?
