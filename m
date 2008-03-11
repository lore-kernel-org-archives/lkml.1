Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYCKHlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYCKHlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYCKHk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:40:56 -0400
Received: from web36710.mail.mud.yahoo.com ([209.191.85.44]:36311 "HELO
	web36710.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbYCKHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:40:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yiSDZDed0UNU5JKOjWS3Psgq4Ncvzz8NoARvLaYuojy6zNXiMgljYCT9Hzn0HNp1sBo/NwPlgg4zr4243UjO/j2CIofaLL7sQ/Jvs/jpWTOzcQnkIQc3ZlhuSrxB/TMU4HbjAPQguCyHdfbzAQtv6LQS5wzYoLzcXTrcvvSi98k=;
X-YMail-OSG: .y.vj5QVM1nPVe4vY.sW5n8Z.Jl98azz5t0u9tgxBXeAqYaxqJsZtITle.FonbOelA1OykPakLy8SGCCdj_Wj0hy_kl5i26NOU13HAuXWlqB1GnS_Mw-
Date: Tue, 11 Mar 2008 00:40:54 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: MMC: logical-bitwise and confusion in  tifm_sd_transfer_data()?
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: lkml <linux-kernel@vger.kernel.org>, Roel Kluin <12o3l@tiscali.nl>
In-Reply-To: <20080310135630.5184b87b@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <854975.87080.qm@web36710.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> On Sun, 09 Mar 2008 21:31:08 +0100
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
> > from drivers/mmc/host/tifm_sd.c:183:
> > 
> > if ((r_data->flags & MMC_DATA_WRITE)
> >     && DATA_CARRY)
> > 
> > shouldn't this be bit-wise &?
> 
> First off, I'm not the maintainer of that driver, Alex Dubov is.
> 
> Second, the code seems broken, but not in the way you suggest. It should probably have been:
> 
> if ((r_data->flags & MMC_DATA_WRITE)
> 	&& (host->cmd_flags & DATA_CARRY))
> 

Yes, this is the intended meaning. Can you fix it yourself or should I send a separate patch?



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
