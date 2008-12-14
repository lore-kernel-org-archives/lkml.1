Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYLNXSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYLNXSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYLNXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:18:35 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46634 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYLNXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=taf5vWA6SZf1zqBwZgQVMZ84wgDFcdijvyNf308vgZ3JUM+b4Ok2qoIM3gSf/xOR/U
         eoGlaugB7/6IvcZYl0NiA49cYYEAV13qWEahBFGGOxM3q1IvpJCSk0y4JSwstEz4sf/i
         BQlmOKpEcMwcWpwacsBV1/AgmUK3cwjrxN3OM=
Subject: Re: Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "J.A." =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081214235753.7cd11c51@werewolf.home>
References: <491506DB.1070000@gmail.com>
	 <1229174138.24940.9.camel@maxim-laptop>
	 <20081214235753.7cd11c51@werewolf.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Dec 2008 01:18:28 +0200
Message-Id: <1229296708.12025.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-14 at 23:57 +0100, J.A. Magallón wrote:
> On Sat, 13 Dec 2008 15:15:38 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > 
> > I also noticed, that now the SD only card reader is always enabled
> > regardless of card been there while booting, and same happens in
> > windows, I suspect that this is permanent hardware change, which worries
> > me, but this reader works fine otherwise.
> > (This is another reason why binary bioses are evil, go and find out why
> > it enables it)
> > 
> 
> Which BIOS ? Mine is 3304, kernel is 2.6.28-rc8, and LEFT card is not detected
> unless I use this option:
> 
> options sdhci debug_quirks=1
> 
v0.3301

left read was and does work fine, but before some time it wasn't present
on boot, if there were no card in it, but was hotplugged using acpiphp
when I put it there, but now it is present regardless of card, and I did
no changes in system, so it must be a hardware malfunction/bug.

Best regards,
	Maxim Levitsky

