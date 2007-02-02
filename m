Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbXBBLEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbXBBLEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXBBLEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:04:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27219 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbXBBLEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SveR4OeuVStORxcRzdu7aWIjo0MmHrjn6Gr5kxCwGZ6R1e+MRYvU9N2o3WRkUM+tPIcgw7fevvodO/xjut7uP4NSheaTGHltUI400e6c5RnNgswhfiCOGx3MUw8yYYI+xpl55JVpN663g/hK3YjGwRmXvNHrUTyC4veJhWzaZfs=
Message-ID: <65258a580702020304m52283349ne4ba2895d9ce7188@mail.gmail.com>
Date: Fri, 2 Feb 2007 12:04:47 +0100
From: "Vincent Vanackere" <vincent.vanackere@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation (Was: Free Linux Driver Development!)
Cc: lirc@bartelmus.de, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>  [...]
>  drivers/lirc_atiusb/lirc_atiusb.c           |  102 -----------------
                              ^^^^^^^^^^^^^^

 I may be mistaken, but the lirc_atiusb module looks redondant with
the driver already in drivers/usb/input/ati_remote.c.
Moreover, I was under the impression that the input layer was
currently considered the "right way" to implement the kernel side lirc
needs (AFAICT the lircd daemon is already able to handle events from
the input layer).

So I'm wondering : in view of a kernel merge, wouldn't it be better
for the lirc drivers to be ported to the input layer (linux-input ML
in cc:) ?

Regards,

Vincent
