Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0BCRop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:44:45 -0500
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:39404 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932685Ab0BCRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:44:42 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2010 12:44:42 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=wruejGAiKs3B05yaejkDUX4+fsYvde7sLoCcGf2SrPbc8WsXDIUr3OzaJditTsKekfouKiOcnJ2SlTQzzmWygobwNeoisvaluL0gNk8QyGeM7u248JMjj4YJ9Z98U6XzbmReaOd3RUhbh5MOW7pWsg8THlMuzXk/Ygfx07Mz+t0=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: c.9SlacVM1lE6TOvDNHMGbQw9qv1lcuVEzQBo4UW3Pprfh6iY.AxY72jjxeKORUpkmtgMOpUsm.B39.OAkmhUNFKwTet1Al8xdwTZxtNbTN3LlL31AxG34g.4x2PPS9J3YtXeVHjwbImeY9U6KrAA4pJnYoubIJ9ybzNUeuQo0hzN8o.koNvEaM3ab3r2mHTxiB_euYVwPbbG2pDkfQBeMUCeeeP2yZ3q4pby.DFn.wJTH4eT7pL6RBeKWopaIn02FpJT3naDe.mSjoBBA__a92qbnWhkBAC
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B69B473.5030607@yahoo.es>
Date: Wed, 03 Feb 2010 18:37:55 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       vamos@i4.informatik.uni-erlangen.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix CONFIG_SSB_SDIOHOST typo
References: <20100203152322.GA7167@faui49.informatik.uni-erlangen.de> <201002031824.37215.mb@bu3sch.de>
In-Reply-To: <201002031824.37215.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> This fixes a CONFIG_SSB_SDIOHOST typo.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> 
> ---
>  drivers/ssb/main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- wireless-testing.orig/drivers/ssb/main.c
> +++ wireless-testing/drivers/ssb/main.c
> @@ -494,8 +494,7 @@ static int ssb_devices_register(struct s
>  #endif
>  			break;
>  		case SSB_BUSTYPE_SDIO:
> -#ifdef CONFIG_SSB_SDIO
> -			sdev->irq = bus->host_sdio->dev.irq;
> +#ifdef CONFIG_SSB_SDIOHOST
>  			dev->parent = &bus->host_sdio->dev;
>  #endif
>  			break;
> 

Tested-By: Albert Herranz <albert_herranz@yahoo.es>

Thanks,
Albert
