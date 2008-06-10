Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYFJTg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYFJTg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYFJTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:36:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYFJTgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:36:51 -0400
Message-ID: <484ED76B.6050504@redhat.com>
Date: Tue, 10 Jun 2008 15:35:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, ananth@in.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kprobes: remove redundant config check
References: <484EB61E.7050509@gmail.com>
In-Reply-To: <484EB61E.7050509@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> Hi,
> 
> I noticed that there's a CONFIG_KPROBES check inside kernel/kprobes.c,
> which seems redundant. Can be removed?

Yes, it can be removed, because kernel/kprobes.c is not complied when
CONFIG_KPROBES=n.

Thank you,

> 
> Diff'd against v2.6.26-rc5.
> 
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

