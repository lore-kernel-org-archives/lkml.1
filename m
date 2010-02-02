Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0BBF6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 00:58:32 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37694 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0BBF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 00:58:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NrjKPHEfLwIlC4gGbLNyKvGPQOfDCIlQiNqSGYBoX13VMw1JmtC9x+netVG+Kce6uA
         4H0m19kgFbKXlloRIyVxNaSHzMT938EkCBdvDH5NyPrRQYwahWX0CYhpnsm6OVVZNyUZ
         ajVKmfq/InC+1jjnbSu0Syi/I1TWL2aEVteSM=
Subject: Re: [PATCH] cfi.h: quiet sparse noise
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org
In-Reply-To: <201001151109.32890.hartleys@visionengravers.com>
References: <201001151109.32890.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 07:58:25 +0200
Message-Id: <1265090305.2517.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 11:09 -0700, H Hartley Sweeten wrote:
> cfi.h: quiet sparse noise
> 
> In the inline function cfi_build_cmd_addr, the cast of cmd_ofs to an
> uint8_t produces a sparse warning of the type:
> 
> warning: cast truncates bits from constant value (2aa becomes aa)
> 
> Quiet the warning by masking cmd_ofs with 0xff and remove the cast.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

Pushed this one to my l2-mtd-2.6 / master
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

