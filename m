Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZCWUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZCWUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZCWUJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:09:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60382 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZCWUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZNkrjrq5R9AB69pyjf4Dg8wxYVNqd54uWFFysjBF6S4KFJsGerPgh3KKJGQh7cOW1I
         wdIGLh/dZPGwXfoG7VoP8JaFGP2+HiljmqZBo/aK62H6jUgYjftLgXFqLxFNCsrhajOK
         ejHyjyNJZ22jJVCqAZKqnpjtpx3YmQVe0Qh10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Gilles Espinasse" <g.esp@free.fr>
Subject: Re: [PATCH] Be able to build pmac driver without IDE built-in
Date: Mon, 23 Mar 2009 21:12:21 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090320; KDE/4.2.1; i686; ; )
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, benh@kernel.crashing.org
References: <0a0401c9a8b9$fa181c30$f9b5a8c0@pii350>
In-Reply-To: <0a0401c9a8b9$fa181c30$f9b5a8c0@pii350>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903232112.21291.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009, Gilles Espinasse wrote:
> No reason to need IDE built-in to be able to compile pmac driver
> Tested to work on 2.6.29-rc8 and 2.6.28.8 with ide and pmac as modules
> inside an initramfs
> 
>  Signed-off-by: Gilles Espinasse <g.esp@free.fr>

applied by hand (please check your mailer settings
as it seems to corrupt whitespaces)

> --- linux-2.6.28/drivers/ide/Kconfig.old 2009-03-19 16:36:34.000000000 +0100
> +++ linux-2.6.28/drivers/ide/Kconfig 2009-03-19 16:35:49.000000000 +0100
> @@ -676,7 +676,7 @@
>  # TODO: BLK_DEV_IDEDMA_PCI -> BLK_DEV_IDEDMA_SFF
>  config BLK_DEV_IDE_PMAC
>   tristate "PowerMac on-board IDE support"
> - depends on PPC_PMAC && IDE=y
> + depends on PPC_PMAC && IDE

IDE config options are covered by if IDE ... endif so no need to check
for IDE explicitly now (I cleaned this while applying the patch)
