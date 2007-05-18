Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbXERSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbXERSO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXERSMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:12:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763468AbXERSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:12:01 -0400
Date: Fri, 18 May 2007 11:10:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Char: cyclades, add firmware loading
Message-Id: <20070518111048.55e9d811.akpm@linux-foundation.org>
In-Reply-To: <2258930840122446564@wsc.cz>
References: <2258930840122446564@wsc.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 19:49:11 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> cyclades, add firmware loading
> 

eww, it adds a variable called "tmp".

This change isn't appropriate to 2.6.22.

The second patch fixes a bug in 2.6.22-rc1 and in 2.6.21 (yes?) but
includes irrelevant changes which aren't appropriate to 2.6.22 and which
depend on patch #1.

So I split the bugfix out into a separate patch.
