Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZFAUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZFAUeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZFAUeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:34:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZFAUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XNDEoE7UoUem2SsT0QNhSg6RAr31+pNUShRzmXH29GbRyFOAz+51eEb+lNvUsAigkl
         wUCbV2mv1rWDB18SEBMV4EGEvm7EL3w0obQZIflS+fOEfKo+r/4MRA+dFeQDJdPcaSc9
         VlK2dmoqNWkrbMcgoE/mfyQJMa4zSqJDyvGc4=
Date: Tue, 2 Jun 2009 00:33:48 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Subject: Re: [PATCH 10/10] ieee802154: add at86rf230/rf231 spi driver
Message-ID: <20090601203348.GC7143@doriath.ww600.siemens.net>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-10-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-11-git-send-email-dbaryshkov@gmail.com> <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 06:21:37PM +0200, Gábor Stefanik wrote:
> On Mon, Jun 1, 2009 at 4:54 PM, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
> > Add a driver handling AT86RF230/RF231 line of chips. Only basic
> > features are currently implemented (no extended mode operation, etc.)
> > Also the RF230 chip is not really supported yet.
> >
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Signed-off-by: Sergey Lapin <slapin@ossfans.org>
> > ---
> >  drivers/ieee802154/Kconfig     |    5 +
> >  drivers/ieee802154/Makefile    |    1 +
> >  drivers/ieee802154/at86rf230.c |  971 ++++++++++++++++++++++++++++++++++++++++
> 
> Shouldn't this go into drivers/net/ieee802154 instead?

I thought about drivers/net as about ip (well, more or less) network
drivers. We have drivers/atm or drivers/bluetooth (and bluetooth is
802.15.1...). So we've used just drivers/ieee802154. If you say so,
we will move to drivers/net.

-- 
With best wishes
Dmitry

