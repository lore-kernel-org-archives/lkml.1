Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbXIVBtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbXIVBtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 21:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXIVBtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 21:49:06 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3780 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbXIVBtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 21:49:04 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: vda.linux@googlemail.com, jeff@garzik.org, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <20070921.104912.41646795.davem@davemloft.net>
References: <200709211201.24475.vda.linux@googlemail.com>
 <20070921.091432.74736040.davem@davemloft.net>
 <200709211803.55554.vda.linux@googlemail.com>
 <20070921.104912.41646795.davem@davemloft.net>
Date: Fri, 21 Sep 2007 19:47:17 -0700
Message-ID: <1190429237.4957.6.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEAAB0B3K44689793-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 10:49 -0700, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Fri, 21 Sep 2007 18:03:55 +0100
> 
> > Do patches look ok to you?
> 
> I'm travelling so I haven't looked closely yet :-)
> 
> Michael can take a look and I'll try to do so as well
> tonight.
> 

I've already reviewed the earlier versions of the patch and have made
some suggestions.  This latest one looks ok to me and tested ok.

I'll follow up later with another patch to remove all the zeros in other
firmware sections, and to remove the gzip headers completely.

Acked-by: Michael Chan <mchan@broadcom.com>

