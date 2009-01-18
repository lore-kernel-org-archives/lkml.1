Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZARFB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZARFB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZARFBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:01:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:53507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZARFBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:01:49 -0500
Message-ID: <4972B7B6.6000901@kernel.org>
Date: Sun, 18 Jan 2009 14:01:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-3-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 05:01:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, one more thing.

Brian Gerst wrote:
> +unsigned char is_boot_cpu = 1;
> +

Comment saying that it's reference in head_64.S would be nice.

-- 
tejun
