Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYBEDny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYBEDny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYBEDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:43:47 -0500
Received: from ozlabs.org ([203.10.76.45]:39814 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYBEDnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:43:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH] Whine about suspicious return values from module's ->init() hook
Date: Tue, 5 Feb 2008 14:43:31 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20080204154215.GA26618@localhost.sw.ru>
In-Reply-To: <20080204154215.GA26618@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051443.31783.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 02:42:15 Alexey Dobriyan wrote:
> One head-scratching session could be noticeably shorter with this patch...
>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

If we want to prevent > 0 returns, let's just BUG_ON().

Thanks,
Rusty.
