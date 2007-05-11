Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXEKWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXEKWK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbXEKWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:10:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43589 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487AbXEKWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:10:19 -0400
Message-ID: <4644E9C6.60004@garzik.org>
Date: Fri, 11 May 2007 18:10:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error,
 take#2
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com> <4642627A.4030606@garzik.org> <46446311.3000208@gmail.com>
In-Reply-To: <46446311.3000208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> It seems the world isn't as frank as we thought and some devices lie
> about who they are.  Fallback to the other IDENTIFY if IDENTIFY is
> aborted by the device.  As this is the strategy used by IDE for a long
> time, it shouldn't cause too much problem.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: William Thompson <wt@electro-mechanical.com>
> ---
> Updated to fallback iff IDENTIFY is aborted by the device.

applied


