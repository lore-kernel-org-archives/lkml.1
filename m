Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbZAUIVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbZAUIVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZAUIVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:21:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:55544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZAUIVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:21:22 -0500
Message-ID: <4976DAFA.2060500@kernel.org>
Date: Wed, 21 Jan 2009 17:21:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: Merge mmu_context.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-4-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232457345-12366-4-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:21:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> +#ifdef CONFIG_X86_32
> +#define deactivate_mm(tsk, mm)			\
> +do {						\
> +	loadsegment(gs, 0)			\
> +} while (0)

Build fails on x86_32 due to missing ';'.  Fixed patch committed.

-- 
tejun
