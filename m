Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZF1RLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZF1RLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZF1RKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:10:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:54348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZF1RKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:10:53 -0400
Date: Sun, 28 Jun 2009 10:11:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/62] Remove unnecessary semicolons
Message-ID: <20090628101159.4c35a4db@infradead.org>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 09:26:05 -0700
Joe Perches <joe@perches.com> wrote:

> Found by script
> #! /bin/bash
> 
> from=";\s*;\s*\n"
> to=";\n"
> 
> for file in $(grep -rP --include=*.[ch] -li $from *) ; do
> 
>     perl -i -e \
> 	"local $/; while(<>) { s/$from/$to/g; print; }" $file
> 
> done
> 


can you improve your descriptions please?
to at least include the why for a change, not just the how and what...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
