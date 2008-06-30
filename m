Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYF3PXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYF3PXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYF3PXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:23:40 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:56251 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYF3PXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RP2ycaWHcfJlDKQi1nVJc62DzIl/KV1RgOwN1T9ICNLPeWR+b60OsYahQmmeTW/Gxr
         4nMj6ELPYdu+3WreAPrQXmrKWUYeG+9DirzFziVJTc3DmD30S8pK7lnU6pLTsdQXNflU
         2QvgVHwSYTpI8vm9fRhS0WbqswDOp6F3pdv6Q=
Date: Mon, 30 Jun 2008 11:23:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alastair Bridgewater <nyef_sbcl@lisphacker.com>
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen
	used on HP tx1305us
Message-ID: <20080630112020.ZZRA012@mailhub.coreip.homeip.net>
References: <200806281719.16837.daniel.ritz-ml@swissonline.ch> <200806281757.48201.daniel.ritz-ml@swissonline.ch> <48668070.3040902@lisphacker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48668070.3040902@lisphacker.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alastair,

On Sat, Jun 28, 2008 at 02:18:24PM -0400, Alastair Bridgewater wrote:
>       bInterfaceClass         3 Human Interface Devices
>       bInterfaceSubClass      1 Boot Interface Subclass
>       bInterfaceProtocol      2 Mouse

I think we can try to make usbtouchscreen ignore eGalaxes with
interface class set to HID?

-- 
Dmitry
