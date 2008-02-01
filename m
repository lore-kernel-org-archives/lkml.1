Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYBAQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYBAQWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBAQWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:22:35 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:1107 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYBAQWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:22:35 -0500
Date: Fri, 1 Feb 2008 17:22:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201162232.GD29660@osiris.boeblingen.de.ibm.com>
References: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com> <20080201132854.GB13251@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201132854.GB13251@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config HAVE_LATENCYTOP_SUPPORT
> > +	def_bool y
> > +
> No.
> Please do:
>  config X86
> +	select HAVE_LATENCYTOP_SUPPORT
> 
> Yes - this is a valid use of select.
> 
> See Documentation/kbuild/kconfig-language.txt

Ok, I wasn't aware of that. For now I'll leave it as is
as Ingo requested.
