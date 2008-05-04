Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbYEDTHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbYEDTHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYEDTHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:07:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52064 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYEDTH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:07:26 -0400
Date: Sun, 4 May 2008 21:08:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mconf.c and bindtextdomain() -- warnings while cross-compiling on OS X
Message-ID: <20080504190800.GA23619@uranus.ravnborg.org>
References: <481D344C.9080904@tabi.org> <20080504073313.GA16259@uranus.ravnborg.org> <481E039A.9090605@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481E039A.9090605@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:42:34PM -0500, Timur Tabi wrote:
> Sam Ravnborg wrote:
> 
> >I have queued up following patch. It is obviously correct and builds 
> >without
> >warnings here. Can you give it a try on your box.
> 
> ...
> 
> >+static inline void const char *gettext(const char *txt) { return txt; }
> 
> Drop the "void" on this line and this patch works.
> 
> While you're at it, you'll also need this change:
> 
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -773,7 +773,7 @@ static void conf_string(struct menu *menu)
> 
>         while (1) {
>                 int res;
> -               char *heading;
> +               const char *heading;
> 
> On a side note, git-diff gives me this error in mconf.c:
> 
> @@ -924,4 +924,4 @@ int main(int ac, char **av)
>         }
> 
>         return 0;
> -}
> +}
> \ No newline at end of file
> 
> I've never seen it before so I don't know if this is specific to OS X or 
> maybe it's my editor.

I did your suggested changes and applied the patch.
Will be pushed out in a minute.

	Sam


