Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYGEIbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYGEIbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYGEIbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:31:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:13124 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYGEIbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YjLMYDwe+d4pYUxj3l8TtbmRPvFaYXIUC92Q9ulsRxFVo8y2GudoiKBKrcE3Sbu7cs
         T68rk2036+PygQUoSNw2QyycDXj02kvVa2uezKSIpTJtQQ9JUwuMNE3T5vj9tH5RTEhq
         cO4rJ4hYMt43ci67xt8EHxZ3PwMfsgaqgv1xc=
Date: Sat, 5 Jul 2008 12:31:22 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Takashi Iwai <tiwai@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Message-ID: <20080705083122.GA7026@doriath.ww600.siemens.net>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704142208.GB4576@doriath.ww600.siemens.net> <s5hwsk1k6yj.wl%tiwai@suse.de> <200807040954.34838.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807040954.34838.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 09:54:34AM -0700, David Brownell wrote:
> On Friday 04 July 2008, Takashi Iwai wrote:
> > 
> > > Please submit a patch where HAVE_GPIO_LIB selects GENERIC_GPIO.
> > 
> > Hmm... just checking again, I found GENERIC_GPIO isn't defined in
> > drivers/gpio/Kconfig but in each arch Kconfig.  So we can't select it
> > unconditionally.
> > 
> > I'm not sure whether it's a better fix at this moment.
> 
> Which platform is it which is trying to declare that it has
> an implementation (HAVE_GPIO_LIB) of an interface that it
> doesn't support (GENERIC_GPIO unset) ??

the powerpc with PPC_MPC52xx=y, PPC_MPC5200_GPIO=y

-- 
With best wishes
Dmitry

