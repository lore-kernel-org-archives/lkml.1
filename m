Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbXJYIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbXJYIQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbXJYIP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:15:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465AbXJYIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:15:23 -0400
Date: Thu, 25 Oct 2007 01:15:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] Permit silencing of __deprecated warnings.
Message-Id: <20071025011516.aea17222.akpm@linux-foundation.org>
In-Reply-To: <41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
	<41621d56a0a0e4e5f861e1725f18990df5e927ad.1193299380.git.jeff@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 04:06:13 -0400 (EDT) Jeff Garzik <jeff@garzik.org> wrote:

> The __deprecated marker is quite useful in highlighting the remnants of
> old APIs that want removing.
> 
> However, it is quite normal for one or more years to pass, before the
> (usually ancient, bitrotten) code in question is either updated or
> deleted.
> 
> Thus, like __must_check, add a Kconfig option that permits the silencing
> of this compiler warning.
> 
> This change mimics the ifdef-ery and Kconfig defaults of MUST_CHECK as
> closely as possible.

Sigh.  Can't we just fix the dud code?  Or mark it BROKEN and see what
happens?
