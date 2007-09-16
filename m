Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXIPR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXIPR7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXIPR7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:59:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4130 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXIPR7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:59:30 -0400
Date: Sun, 16 Sep 2007 19:59:56 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Matej Laitl <strohel@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] menuconfig: distinguish between selected-by-another
 options and comments
In-Reply-To: <200709161944.31780.strohel@gmail.com>
Message-ID: <Pine.LNX.4.64.0709161955340.1817@scrub.home>
References: <200709152004.11930.strohel@gmail.com> <200709161944.31780.strohel@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 16 Sep 2007, Matej Laitl wrote:

> +tristate sym_get_minimal_value(struct symbol *sym)
> +{
> +	return sym->rev_dep.tri;
> +}
> +
> +tristate sym_get_maximal_value(struct symbol *sym)
> +{
> +	return sym->visible;
> +}
> +

Right now I prefer the previous version. This maximum value is overridden 
by the minimum value, so I wouldn't like it to be exported like this.

I would really like to see an example, where the new changes make a 
difference.

bye, Roman
