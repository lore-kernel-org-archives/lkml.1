Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYBZFVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYBZFVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYBZFVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:21:42 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:12875 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492AbYBZFVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:21:41 -0500
Date: Tue, 26 Feb 2008 14:21:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-sh@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/sh/drivers/heartbeat.c ioremap is expected to succeed
Message-ID: <20080226052138.GC19814@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roel Kluin <12o3l@tiscali.nl>, linux-sh@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
References: <47B98376.5040906@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B98376.5040906@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 02:09:10PM +0100, Roel Kluin wrote:
> !unlikely(hd->base) is equivalent to likely(!hd->base) (for instance see
> comments with commit fd312561adcc90e924f35d3032d5493aeb4c3017), I think
> the ioremap is expected to succeed? please confirm that's right.
> The patch below was *not* tested.
> ---
> ioremap is expected to succeed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Indeed it is. Applied, thanks.
