Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYBYW14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYBYW14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbYBYW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:27:45 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36220 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbYBYW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:27:44 -0500
Date: Tue, 26 Feb 2008 01:26:17 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Matt Reimer <mreimer@vpop.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] [W1] ds1wm: should check for IS_ERR(clk) instead of NULL
Message-ID: <20080225222617.GA11899@2ka.mipt.ru>
References: <20080225212426.GA29891@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225212426.GA29891@zarina>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton.

On Tue, Feb 26, 2008 at 12:24:26AM +0300, Anton Vorontsov (cbouatmailru@gmail.com) wrote:
> On the error condition clk_get() returns ERR_PTR(..), so checking
> for NULL doesn't work. ds1wm module causes a kernel oops when ds1wm
> clock isn't registered.
> 
> This patch converts NULL check to IS_ERR(), plus uses PTR_ERR()
> for the return code.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Both patches look good, thanks Anton.

Andrew, please merge them and add my ack if needed.
Thank you.

-- 
	Evgeniy Polyakov
