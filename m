Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbXIOSot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbXIOSot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXIOSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:44:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:20231 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXIOSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ph/wlfuew4HIL11pBl0VbJSSknCU1uN08BrjKn++sZQB3C6/BaPHHmugil/uxWvMb6qGSZg14V1gvkC5vJV5mIUY3jwImWBL9vwhlJyDWEeo1fL6HlWUjEx6dJWNslSLmjl7E8CUZpRc7KZaTETQz9bWQUBWpkYQJwvNUJocV5E=
From: Matej Laitl <strohel@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Date: Sat, 15 Sep 2007 20:44:30 +0200
User-Agent: KMail/1.9.7
References: <200709152004.11930.strohel@gmail.com> <Pine.LNX.4.64.0709152037460.24423@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709152037460.24423@fbirervta.pbzchgretzou.qr>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709152044.32188.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 of September 2007 20:38:14 you wrote:
> On Sep 15 2007 20:04, Matej Laitl wrote:
> >This patch changes notation of selected-by-another items by introducing 2
> > new representations for implied options:
> >{*} or {M} for options selected by another modularized one, thus builtin
> > or module capable,
> >-*- or -M- for options that cannot be at the moment changed by user.
>
> This gets rid of the ambiguous ---, does not it? (If so, nice!)

Definately. You may try it, the patch is against current Linus's HEAD, but may 
apply cleanly also against 2.6.22 as none of the files changed since. (AFAIK, 
too lazy to check it)

Regards,
         Matej
