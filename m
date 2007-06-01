Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXFAGku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXFAGku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXFAGkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:40:43 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbXFAGkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:40:42 -0400
Date: Thu, 31 May 2007 23:40:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
Message-Id: <20070531234037.bebbc659.akpm@linux-foundation.org>
In-Reply-To: <465FAD94.4020200@drzeus.cx>
References: <4655834F.3050301@drzeus.cx>
	<20070524170654.5d674474.akpm@linux-foundation.org>
	<4656602A.3010000@drzeus.cx>
	<20070524211737.daa3c99c.akpm@linux-foundation.org>
	<465666AE.5020600@drzeus.cx>
	<465EAF90.3030803@drzeus.cx>
	<20070531085114.420b9cbe.akpm@linux-foundation.org>
	<465FAD94.4020200@drzeus.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 07:24:36 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> +static int __init rootwait_setup(char *line)
> +{
> +	root_wait = simple_strtol(line,NULL,0);
> +	return 1;
> +}
> +
> +__setup("rootwait=", rootwait_setup);

Could we have an update for Documentation/kernel-parameters.txt, please?
