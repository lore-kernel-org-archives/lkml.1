Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZGYRo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZGYRo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZGYRoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:44:55 -0400
Received: from mail-pz0-f172.google.com ([209.85.222.172]:34964 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZGYRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JQLLWNwHStUeEJM6f9kvKYeLiuGFGRlGrJHAEfyTx7WfdXHnYf5a/qt5ErI/EmVn76
         sDYY/L37Q+4ITEi49jQcsmy233lXDaOsU6IUuUpN2CRrrqArWS6/PfOQ4Vx/R1hurtF4
         gfVO4GMc2eNNoCFgpMFT2gtJ3v6jzxWDqxMv4=
Date: Sat, 25 Jul 2009 10:44:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Message-ID: <20090725174449.GC14062@dtor-d630.eng.vmware.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manuel,

On Wed, Jul 22, 2009 at 05:18:39PM +0200, Manuel Lauss wrote:
> Cc: Frans Pop <elendil@planet.nl>
> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
>
> +
> +static struct dev_pm_ops au1xmmc_pmops = {
> +	.resume		= au1xmmc_resume,
> +	.suspend	= au1xmmc_suspend,
> +};
> +

Was suspend to disk tested? It requires freeze()/thaw().

-- 
Dmitry
