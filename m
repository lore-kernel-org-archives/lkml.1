Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZBXWMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZBXWMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbZBXWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:12:13 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:28937 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760277AbZBXWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:12:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gLGy04TFT842+SCocemG/XoJsxlAgF8zTnfI7nlo3t6pJOBzdBJYMR8XGkLXgeQutx28mWNKcRX5Yrjh6/Mv3LKIdEIbbtTaIvdMsZdDsJueetLN4xcNR4CsrGqY0CfWT7BeCy818SWT2FuBk2dUFbXTYSS6NQIXsIUV1P7K5DQ=  ;
X-YMail-OSG: F8_fQwwVM1kLjilCK35kjphrgJUq3oyxvBBO_zo5WBUy1VIgJKosn.Fbl97NRjeo7iOWOJE.ErsFYYkTAL.8Ju1cDXMA_QNtqRc06x98sZtL5hC2ETkNOy7oyZWFTpiqZlOdxszvy4I8aF.j_z8ibl_NYDz2SAaugm3UxoqWFu4KTGSKTxj27ApQfKle
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when resuming
Date: Tue, 24 Feb 2009 14:12:07 -0800
User-Agent: KMail/1.9.10
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?q?=B1=E8=B1=D4=BF=F8?= <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <200902231023.49653.david-b@pacbell.net> <49A3EF96.3090603@nokia.com>
In-Reply-To: <49A3EF96.3090603@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902241412.08043.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Adrian Hunter wrote:
> I would still like the other two issues I raised considered.
> They were:
>         1.  'host' can be NULL in omap_mmc_suspend() / omap_mmc_resume()
>         2. wait for SDBP bit

Someone from Nokia was going to be shepherding HSMMC patches,
as I recall... that person should deal with these issues.  :)

