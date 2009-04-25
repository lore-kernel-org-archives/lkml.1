Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZDYHYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZDYHYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 03:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZDYHYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 03:24:16 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51542 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZDYHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 03:24:16 -0400
Date: Sat, 25 Apr 2009 09:26:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: clean Module.markers and modules.order for out-of-tree modules
Message-ID: <20090425072624.GA27747@uranus.ravnborg.org>
References: <1240160320-7466-1-git-send-email-fbriere@fbriere.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1240160320-7466-1-git-send-email-fbriere@fbriere.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 12:58:40PM -0400, Frédéric Brière wrote:
> 
> Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
> ---
>  Makefile |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index bfdef56..afbef69 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1421,7 +1421,9 @@ $(clean-dirs):
>  	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
>  
>  clean:	rm-dirs := $(MODVERDIR)
> -clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers
> +clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
> +                   $(KBUILD_EXTMOD)/Module.markers \
> +                   $(KBUILD_EXTMOD)/modules.order
>  clean: $(clean-dirs)
>  	$(call cmd,rmdirs)
>  	$(call cmd,rmfiles)

Applied,
	Sam
