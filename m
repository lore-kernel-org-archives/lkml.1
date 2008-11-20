Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYKTUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYKTUyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbYKTUvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:44 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22371 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756864AbYKTUvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hwJd7wqPd7OS8U2MOE4ffFFmAfZnm4Rnv3G7ErCJtKXfmYblSQnHmyOmCJjWRYBKEwLtbAUcI4vug/yOXNrYF0LQttm/bTUM4gig5jzWS+gkGpYrkRAnbAH7OzGVEU36cjnLeVkq/staZPXY7ktaEzB3RATDpe7+DRhdeY8Y9b8=  ;
X-YMail-OSG: hsKWq2gVM1ngh4lVkURLZSW8yHpsOsHyFC2HGzxHRSfy4ck6uYtGD8BK6tMCC.9I_DnacopxFvhdx67f2yh7CswnprtmJtzmHvTAsghNv4a_UXyQT4fTKC59Da5qGIAcU16nvLuIRGBt1BTOgsJLanJQ1sLBm4o_Z9QObapA58f6opjj5ETAaPiLtLRd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 10/16] Blackfin SPI Driver: use the properl BIT_CTL_xxx defines
Date: Thu, 20 Nov 2008 12:37:42 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-11-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-11-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201237.43180.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> use the properl BIT_CTL_... defines rather than the internal driv
> er CFG_SPI_... defines
> 

> @@ -821,12 +821,9 @@ static void pump_transfers(unsigned long data)
>  							(unsigned long) (drv_data->rx +
>  							drv_data->len_in_bytes));
>  
> -			/* clear tx reg soformer data is not shifted out */
> -			write_TDBR(drv_data, 0xFFFF);
> -

This is unrelated to a BIT_CTL #define.  It's a bug in
either the patch or its comment.


>  			dma_config |= WNR;
>  			dma_start_addr = (unsigned long)drv_data->rx;
