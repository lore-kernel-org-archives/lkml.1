Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207Ab0B0RId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:08:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:54365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968613Ab0B0RIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:08:32 -0500
Date: Sat, 27 Feb 2010 09:10:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
Message-ID: <20100227091039.7608155c@infradead.org>
In-Reply-To: <20100227150942.GA6394@elte.hu>
References: <20100227150942.GA6394@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 16:09:42 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> +int wbinvd_on_all_cpus(void)
> +{
> +	return on_each_cpu(__wbinvd, NULL, 1);
> +}

does this make sense at all?

doesn't cache coherency on x86 already guarantee this?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
