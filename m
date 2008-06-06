Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbYFFTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbYFFTwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYFFTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:52:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:64564 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYFFTwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gmqk8njesb+ICeyy6pXwPx2/l57AOA139kWmNAM2LDuKTWvOE5tVECKKUpE4Zcr8Hi
         w/RhGeRt7YaDCbHV4kKvsk5S8enil240U96+ncj0TbeLQ1HRCzraCPt6xHCgHnrHxVjV
         1l8HbgASXL5R3bttf51L2xrazV6p/C1Ni+VIg=
Message-ID: <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
Date: Fri, 6 Jun 2008 15:52:09 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: blackfin drivers/net/smc91x.c build error
Cc: "Bryan Wu" <cooloney@kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080606162212.GC2201@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162212.GC2201@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 12:22 PM, Adrian Bunk <bunk@kernel.org> wrote:
> drivers/net/smc91x.c fails as follows on blackfin:
> ...
>  CC      drivers/net/smc91x.o
> ...
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/smc91x.c:1863:36: error: macro "SMC_GET_MAC_ADDR" passed 2 arguments, but takes just 1
> ...

it's a known issue (been known for quite a long time actually).  Bryan
has brought this up in the past already.
-mike
