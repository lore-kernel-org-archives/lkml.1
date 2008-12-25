Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYLYVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYLYVAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 16:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYLYU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:59:11 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:63047 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYLYU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z9tKT1tVk7LCYCBmNes7ktjlYsXsYbVDHpCJhFe3h1fkBZQBLEiXdouptqevE0eAdJ
         RqT6lG+MndlrD12fenCgvqBL5C9InI0KeFWPEYCjEKIiQkay3s/Fg6H+V0mqhu2sifqz
         yYXw3mD5OwxssHHoctkMOBUcW/TBhlysXte14=
Date: Fri, 26 Dec 2008 00:03:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Patrizio Bassi <patrizio.bassi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.28 kseriod oops on resume afte hibernation
Message-ID: <20081225210355.GA7105@x200.localdomain>
References: <742b1fb30812251225o38a2e4bak2d9f10ca3c23ada3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <742b1fb30812251225o38a2e4bak2d9f10ca3c23ada3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 09:25:38PM +0100, Patrizio Bassi wrote:
> Call Trace:
>  [<c027ac74>] 0xc027ac74
>  [<c0124598>] 0xc0124598
>  [<c027cd1c>] 0xc027cd1c
>  [<c02750a2>] 0xc02750a2
>  [<c0275587>] 0xc0275587
>  [<c0124598>] 0xc0124598
>  [<c0275482>] 0xc0275482
>  [<c01242ab>] 0xc01242ab
>  [<c0124275>] 0xc0124275
>  [<c0103823>] 0xc0103823
> Code: 37 c0 31 c0 c7 47 58 1c 87 37 c0 5e 5b 5e 5f 5d c3 55 57 56 53
> 83 ec 28 fc b9 06 00 00 00 89 c3 8b 00 8d 7c 24 10 89 04 24 89 c6 <f3>
> a5 8b 44 24 14 8b 54 24 18 8b 7c 24 1c 8b 6c 24 10 89 44 24
> EIP: [<c027dbdf>]  SS:ESP 0068:d28b3f54
> ---[ end trace e760723794b1da56 ]---

Always run with CONFIG_KALSYMS=y, so normal backtraces are on
and nobody will waste time asking to enable it and enabling it.
