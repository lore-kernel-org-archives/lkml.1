Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZFRB70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZFRB70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZFRB7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:59:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52534 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZFRB7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:59:18 -0400
Message-ID: <4A399F6D.2070502@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 10:59:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use zalloc_cpumask_var for mce_dev_initialized -v2
References: <4A396361.2000302@kernel.org> <4A397A7D.5090608@kernel.org>
In-Reply-To: <4A397A7D.5090608@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> need to get cleared cpu_mask about if mce device is initialized.
> esp when MAXSMP is used.
> 
> used zalloc_... instead
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org

Good catch!

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

