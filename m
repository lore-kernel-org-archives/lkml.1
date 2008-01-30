Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbYA3XKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbYA3XKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYA3XKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:10:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbYA3XKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:10:35 -0500
Date: Wed, 30 Jan 2008 15:10:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, jirislaby@gmail.com,
       xiyou.wangcong@gmail.com
Subject: Re: [PATCH 2/2] Char: applicom, use pci_match_id
Message-Id: <20080130151022.c52ad664.akpm@linux-foundation.org>
In-Reply-To: <1201691595-11448-2-git-send-email-jirislaby@gmail.com>
References: <20080128054917.GA10504@hacking>
	<1201691595-11448-2-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 12:13:15 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> +		if (!pci_match_id(applicom_pci_tbl, dev));
>  			continue;


The patch was carelessly prepared, was not runtine-tested and was not
passed through checkpatch, which detects this error.  Please fix these
things, permanently.

It's hard to overemphasise how out-of-balance the economics are here.  You
saved maybe thirty person-seconds by skipping the review and checkpatch
steps.  But the cost (if this bug had gone into mainline) would be many
many thousands times higher than this.
