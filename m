Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZLOQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZLOQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbZLOQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:46:14 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:53755 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbZLOQqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Qe4Noml0Wis13RbKlYjweR0DG6Uwj399fm2pFen74yev5YttLl8w6CayZmG+11+eru
         ZpW6V74aR72SuM6F3nvaRz2FbM/l+Yf2/ih9dTqN4QTAslc48zsmPJWRxqdDVudDeGcT
         g8G6axi+4cQv3mPx8U/EZVpTW/hWsriqbdgVQ=
Date: Tue, 15 Dec 2009 08:45:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] [input] add mc13783 touchscreen driver
Message-ID: <20091215164557.GA21995@core.coreip.homeip.net>
References: <20091212074214.GB2956@core.coreip.homeip.net> <1260871828-358-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260871828-358-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, Dec 15, 2009 at 11:10:28AM +0100, Uwe Kleine-König wrote:
> Hi Dmitry,
> 
> I squashed your changes into this patch, restored my indention style and
> simplified error handling in mc13783_ts_probe to assign ret = -ENOMEM 
> once at the start of the function instead of each error branch.

I prefer to have error defined right before we jump because it allows
reader to see explicitely set error condition instead of having to
verify if earlier code set it properly; it also forces you to set error
conditions on every error branch properly (if you forget while adding a
new one compiler will warn you about uninitialized variable), but I
won't insist.

> 
> In the meantime the changes to mc13783-core are merged in Linus' tree,
> so it can go via your's.
> 

It settled then.

-- 
Dmitry
