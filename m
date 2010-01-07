Return-Path: <linux-kernel-owner+w=401wt.eu-S932963Ab0AGFI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0AGFI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444Ab0AGFI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:08:58 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:36222 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0AGFI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:08:57 -0500
X-Greylist: delayed 2171 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 00:08:55 EST
Date: Wed, 6 Jan 2010 23:32:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uml: line.c: avoid NULL pointer dereference
Message-ID: <20100107043241.GA19313@c2.user-mode-linux.org>
References: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com> <1262828921-29517-2-git-send-email-a.beregalov@gmail.com> <1262828921-29517-3-git-send-email-a.beregalov@gmail.com> <1262828921-29517-4-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262828921-29517-4-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 04:48:41AM +0300, Alexander Beregalov wrote:
> Assign tty only if line is not NULL.

>  	if (line)
> +		tty = line->tty;
>  		chan_interrupt(&line->chan_list, &line->task, tty, irq);
>  	return IRQ_HANDLED;

Even if the thinking is correct, aren't you missing some braces?

				Jeff
