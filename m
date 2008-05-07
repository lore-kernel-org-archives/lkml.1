Return-Path: <linux-kernel-owner+w=401wt.eu-S1765917AbYEGSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765917AbYEGSag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYEGSaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:30:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:11566 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYEGSaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H/qLGbput9c1+F2eG20W5RCyxqKpHPxQP3vqrCs9SqW/+pGoAxzg+ORY29Vgzqkpeh7zBcEhSUM8rwmfvrR+BIJEznQqe398Xqhir50bAYFzlZhOK1IMfFCvo3LVtiyi1988uzTP9rYyFavem9iwphNEkUwl7w5rq7hnqFr86IU=
Message-ID: <86802c440805071130m62c1f4edydb3316dac4a2aba2@mail.gmail.com>
Date: Wed, 7 May 2008 11:30:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesper Krogh" <jesper@krogh.cc>
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4821F3B7.2090702@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4821F3B7.2090702@krogh.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 11:23 AM, Jesper Krogh <jesper@krogh.cc> wrote:
> Hi.
>
>  I get errors like this after a few minutes of traffic on a Sun Neptune 10g
> ethernet card. (with nice 500MB/s throughput).
>
>  Then the server seems too busy with something, so it doesn't even respont
> to a serial terminal login.
>
>  May  7 16:16:33 hest kernel: [  166.948958] niu: niu_get_parent:
> platform_type[1] port[3]
>  May  7 16:16:33 hest kernel: [  166.949366] niu: niu_get_and_validate_port:
> port[3] num_ports[2]
>  May  7 16:16:33 hest kernel: [  166.949886] niu: niu_put_parent: port[3]
>  .. bootup ends here ..
>  May  7 17:13:54 hest kernel: [ 3670.128178] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:04 hest kernel: [ 3680.108614] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:14 hest kernel: [ 3690.093089] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:19 hest kernel: [ 3695.079254] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:24 hest kernel: [ 3700.073525] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:29 hest kernel: [ 3705.063744] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>  May  7 17:14:34 hest kernel: [ 3710.049918] niu 0000:84:00.0: niu: eth4:
> Transmit timed out, resetting
>
>
>  Any suggestions?
>
>  The system is an Ubuntu Hardy (2.6.24-17-server) amd64.

can you try 2.6.25 or current git?

YH
