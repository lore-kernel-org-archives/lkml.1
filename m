Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936126Ab0BZMRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:17:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64981 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936069Ab0BZMQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kURidOBpMcG0PIUjcBS61GyBxj+sCqZETXnxl5YK7BnqKYyngB1lnCqwlr9fNMxEZk
         KqOYLItDykADTecPVGx45y2wYJ+7kxGYtVEP8ennCVtDwqxHOa/u81QtDPJJWoUn1iIH
         IFxDtjtu586cVZMbrvdT2cxMRq2yQu8R8dAGs=
Date: Fri, 26 Feb 2010 15:16:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: memory leak in case of Kernel module
Message-ID: <20100226121647.GD8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	naveen yadav <yad.naveen@gmail.com>, linux-kernel@vger.kernel.org
References: <9bde694e1002260244u25cfa332l82c488702e4b9900@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bde694e1002260244u25cfa332l82c488702e4b9900@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 04:14:22PM +0530, naveen yadav wrote:
> Hi all,
> 
> I need small clarification, If I have a kernel module and in init I
> create some memory using vmalloc. and i do not free it. I exit from
> the module.
> 
> what happen to this allocated memory. Will kernel handle it and do free.
> 

No.  You need to free your memory explicitly.

regards,
dan carpenter

> 
> Regards
> Naveen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
