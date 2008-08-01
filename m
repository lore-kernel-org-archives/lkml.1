Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYHAXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYHAXK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYHAXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:10:19 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44553 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYHAXKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:10:18 -0400
Date: Sat, 2 Aug 2008 02:09:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Yudha Harimantoro T <yudha.ht@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Avuton Olrich <avuton@gmail.com>
Subject: Re: Error on Make Modules [2.6.27-rc1]
Message-ID: <20080801230914.GN19682@cs181140183.pp.htv.fi>
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com> <20080801224153.GL19682@cs181140183.pp.htv.fi> <1217631100.3719.44.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217631100.3719.44.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 11:51:40PM +0100, David Woodhouse wrote:
> On Sat, 2008-08-02 at 01:41 +0300, Adrian Bunk wrote:
> > Can you somehow hide this message?
> 
> I'll leave the __fw_install one alone, so that if there's nothing to do
> for 'make firmware_install' it says so rather than just doing nothing.
> The other two can shut up, as requested.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
> index f63a663..6bf8e87 100644
> --- a/scripts/Makefile.fwinst
> +++ b/scripts/Makefile.fwinst
> @@ -50,8 +50,12 @@ PHONY +=  __fw_install __fw_modinst FORCE
>  .PHONY: $(PHONY)
>  
>  __fw_install: $(installed-fw)
> +
>  __fw_modinst: $(installed-mod-fw)
> +	@:
> +
>  __fw_modbuild: $(addprefix $(obj)/,$(mod-fw))
> +	@:
>  
>  FORCE:


Thanks.  :-)


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

