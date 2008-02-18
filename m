Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbYBRSQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbYBRSQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYBRSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:16:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:54187 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYBRSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=BEIW0Iiqr1zOCWsnrYeLDHt/lZOw1HR9YRl7jUZC+eQ9E05UJvXMOx/Cu+1CceZ4TQDLOAYj/EUqTE3mF3IHZ1ZMc+6mg+7PymRgwPI18ff5XW5F8pDqxqTyrsykdnRnWFkcVWMkk8jH7bPa2WG5529ZuxKx/+1XjNBgbHC9A54=
To: "Chris Clayton" <chris2553@googlemail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Mon, 18 Feb 2008 19:16:12 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802181911.32128.IvDoorn@gmail.com>
In-Reply-To: <200802181911.32128.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181916.12746.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost forgot:

> > In 2.6.25 kernels, my wireless LAN dies after even the smallest amount
> > of network activity. The following screen cut shows what I typically
> > see:
> 
> How complete is this failure? Just TX or also RX?
> 
> Could you use the tools found here:
> http://www-user.rhrk.uni-kl.de/~nissler/rt2x00/index.html
> 
> and capture all TX/RX frames going through the hardware?
> Note that after the failure, this dumping facitilty should still report
> any ping request you might send to the interface.

Note that this feature is only present in 2.6.25.

> I have a series of tests I would like to request from you,
> you mentioned you already enabled debugfs, and that is just what we need. ;)
> Please use attached script to create dumps of the hardware register contents.

The debugfs register files were moved into a seperate folder somewhere between
2.6.24 and 2.6.25. This means you might have to edit the file slightly to make it
point to the correct location of the chipset file.

Ivo
