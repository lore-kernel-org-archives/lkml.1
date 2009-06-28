Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZF1SOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZF1SOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZF1SOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:14:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbZF1SOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:14:30 -0400
Date: Sun, 28 Jun 2009 11:12:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH 00/62] Remove unnecessary semicolons
Message-Id: <20090628111207.c1829473.akpm@linux-foundation.org>
In-Reply-To: <20090628101159.4c35a4db@infradead.org>
References: <cover.1246173664.git.joe@perches.com>
	<20090628101159.4c35a4db@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 10:11:59 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 28 Jun 2009 09:26:05 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Found by script
> > #! /bin/bash
> > 
> > from=";\s*;\s*\n"
> > to=";\n"
> > 
> > for file in $(grep -rP --include=*.[ch] -li $from *) ; do
> > 
> >     perl -i -e \
> > 	"local $/; while(<>) { s/$from/$to/g; print; }" $file
> > 
> > done
> > 
> 
> 
> can you improve your descriptions please?
> to at least include the why for a change, not just the how and what...

The [0/n] text doesn't get into git anyway (unless someone manually
copies-n-pastes it).

Each of the actual patches have no changelog at all, and they don't
need one - it's utterly obvious what they're doing.

So I don't believe that anything needs to be changed here.

