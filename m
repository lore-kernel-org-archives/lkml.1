Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZAEOMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZAEOMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZAEOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:12:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:55131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZAEOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gPhVXl8frs43ATj5u5Utov/0ePoga6AWBuj703DrQ8bej6GqEJcSmonOHWD4396y64
         ULhGT2j14MM8TwyS5BCwD6F6AwvNGrak2zJ+2O2ypuFYl9T285Jfg1BTMaLZUP4xCCZq
         jxuRbWgU/ldoRShDi640D1zbuQqAuDhsS6uRg=
Message-ID: <3f9a31f40901050612v700d2542r1e3e400bf0fe3d33@mail.gmail.com>
Date: Mon, 5 Jan 2009 19:42:37 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Oliver Hartkopp" <oliver@hartkopp.net>,
       "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to request_firmware()
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>, davem@redhat.com,
       jgarzik@redhat.com, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mchan@broadcom.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <49620AFE.6040409@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230626497.24796.26.camel@jaswinder.satnam>
	 <49620AFE.6040409@hartkopp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 6:58 PM, Oliver Hartkopp <oliver@hartkopp.net> wrote:
> 077f849de42e58172e25ccb24df4c1a13e82420c ("firmware: convert tg3 driver to
> request_firmware()")
>
> and i discovered that
>
> 1. I needed to compile the tg3 driver as *module* now as it was not able to
> read the firmware when built-in.
>

Please compile it as build in.

David Woodhouse: Do you have any plans to support firmware by using modules.

Thanks,
JSR.
