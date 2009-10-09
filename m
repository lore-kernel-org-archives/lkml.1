Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbZJIIUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbZJIIUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZJIIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:20:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:51624 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZJIIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VCAOGYAtMeiIWzLfDyMVdMKOX9587XgCBNsmvzodqt0BjXHEIRmhIhlQpoWdkC36HD
         8oc6yl83wrSlCxQQDce4DXVqUPHHjw54+2u7ugrfffiRKU/I5THCY+smeWa+HkSkicP/
         OPxgE6RdbqrKiMTir5Xu9BH3+fVADJ71mxBSg=
Date: Fri, 9 Oct 2009 10:19:11 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Zbynek Drlik <drlik.zbynek@kingparking.sk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ftdi_sio regresion 2.6.31-r1
Message-ID: <20091009081911.GB21054@localhost>
References: <e8eb01770910082357n2d4fa33dk75b6c45f55bebcbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8eb01770910082357n2d4fa33dk75b6c45f55bebcbd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After upgrade kernel from 2.6.30 to 2.6.31-r1 my device connected by
> ftdi converter stop working. This device use rts/cts handshake.
> In this thread
> http://www.gossamer-threads.com/lists/linux/kernel/1128189
> i see that similar problem is reported, but in my situation, reconnect
> doesn't help. Write is ok. Read not ok.

This will most likely be fixed by the following patches (against
2.6.32-rc3):

	http://lkml.org/lkml/2009/10/7/422

/Johan

