Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYHDNCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYHDNCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYHDNCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:02:16 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:41210 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYHDNCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=W6aU3bLM1/e6cG+p+i7I06HuVYde5F6xjjvZj4TAQNOplqXWXLfiaB0VArSSfM8lBZ
         cQ1O8cKQttMiuoY/lIoqtSoIMYH1OrY6JIe55uDUe9c1MhHbvkt67PxUTzsStUKhFE4Q
         ibOYNpZNmPg9NBi3A6Cj5doM7RqtCXxTm5I8g=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc (fwd)
Date: Mon, 4 Aug 2008 15:26:08 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080620175729.GA3151@ime.usp.br> <20080620195815.GA2703@ime.usp.br> <20080625194937.GA13636@ime.usp.br>
In-Reply-To: <20080625194937.GA13636@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808041526.08332.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Jun 20 2008, Rogério Brito wrote:
> > On Jun 20 2008, Ivo van Doorn wrote:
> > > 
> > > > Did you receive my earlier message (attached here for reference)? I'm
> > > > willing to experiment with the driver a little bit and I hope that the
> > > > information that I have provided so far is helpful to chase the reason
> > > > why the driver doesn't work on PowerPC.
> > > 
> > > Sorry I have been quite busy with other things.
> > 
> > I'm terribly sorry for that, since I would like the driver to work with
> > the USB stick still in the 2.6.26 release (since that's what some
> > distributions will probably use).
> 
> Just for your information, I just compiled the -rc7 kernel on x86-64 (where
> rt2500usb works if I boot with kernel 2.6.25) and still doesn't work (I'm
> not even mentioning here PowerPC).

I have found the problem and have send it upstream so the patch should
be present in 2.6.27. Note that I am not going to push it to 2.6.26 since
I don't know if the patch will cause problems in other parts of the driver.

Ivo
