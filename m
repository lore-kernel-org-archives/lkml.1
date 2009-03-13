Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZCMUMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZCMUMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZCMUM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:12:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbZCMUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:12:25 -0400
Date: Fri, 13 Mar 2009 13:07:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: laijs@cn.fujitsu.com, pmarques@grupopie.com, mingo@elte.hu,
       srostedt@redhat.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] kallsyms, tracing: output more proper symbol name
Message-Id: <20090313130722.1d92ad80.akpm@linux-foundation.org>
In-Reply-To: <20090313194013.GA23304@uranus.ravnborg.org>
References: <49B7863F.6020804@cn.fujitsu.com>
	<20090311094621.GA13543@elte.hu>
	<49B7B70F.5010908@grupopie.com>
	<49B876BB.50007@cn.fujitsu.com>
	<49B92B25.6020805@grupopie.com>
	<49BA06E2.7080807@cn.fujitsu.com>
	<49BA2704.9040404@cn.fujitsu.com>
	<20090313194013.GA23304@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 20:40:13 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> > This patch puts symbols like "__irqentry_text_start" to the second
> > aliased symbols. And a more proper symbol name becomes the first.
> > 
> > Aliased symbols mostly come from linker script. The solution is
> > guessing "is this symbol defined in linker script", the symbols
> > defined in linker script will not become the first aliased symbol.
> > 
> > And if symbols are found to be equal in this "linker script provided"
> > criteria, symbols are sorted by the number of prefix underscores.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Looks good to me.
> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

So... do we need this in 2.6.29?

I'm about to jump on a plane and shall be a bit intermittent for a week.
