Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYDZGRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYDZGRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYDZGRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:17:38 -0400
Received: from mail.cyberdogtech.com ([64.22.125.39]:59078 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYDZGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:17:37 -0400
Date: Sat, 26 Apr 2008 01:17:33 -0500
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] 2.6.25-git7 - Kconfig Cleanup
Message-Id: <20080426011733.04dedb05.kernel1@cyberdogtech.com>
In-Reply-To: <20080425215037.0b7cead1.randy.dunlap@oracle.com>
References: <20080425232848.b4200d21.kernel1@cyberdogtech.com>
	<20080425215037.0b7cead1.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 21:50:37 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 25 Apr 2008 23:28:48 -0500 Matt LaPlante wrote:
> 
> > Fix misc small typos/grammar in Kconfigs for 2.6.25-git7.
> > 
> > Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> > --
> > 
> > diff -ru a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
> > --- a/arch/cris/arch-v32/Kconfig	2008-04-16 21:49:44.000000000 -0500
> > +++ b/arch/cris/arch-v32/Kconfig	2008-04-25 22:13:14.000000000 -0500
> > @@ -27,8 +27,8 @@
> >  	bool "Use one LED group"
> >  	help
> >  	  Select this if you want one Ethernet LED group. This LED group
> > -	  can be used for one or more Ethernet interfaces. However, it is
> > -	  recomended that each Ethernet interface use a dedicated LED group.
> > +	  can be used for one or more Ethernet interfaces, however it is
> 
> That comma creates a run-on sentence.  Period was better.

My problem is the second sentence starting with "however."  Although it's not technically breaking any rules, writing style guides generally advise against beginning sentences with it... and on a more basic level, I really dislike the way it reads in this case.

May I suggest one of:

- This LED group can be used for one or more Ethernet interfaces, however it is recommended that each interface use a dedicated LED group. 

- This LED group can be used for one or more Ethernet interfaces.  It is still recommended that each interface use a dedicated LED group, however.

- This LED group can be used for one or more Ethernet interfaces. (But it is recommended that each interface use a dedicated LED group.)


> 
> Other than that, looks good.  Thanks.
> 
> > +	  recommended that each Ethernet interface use a dedicated LED group.
> >  
> >  config	ETRAX_NBR_LED_GRP_TWO
> >  	bool "Use two LED groups"
> 
> ---
> ~Randy


-- 
Matt LaPlante
CCNP, CCDP, A+, Linux+, CQS
kernel1@cyberdogtech.com
