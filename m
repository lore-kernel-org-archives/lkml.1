Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYFTSb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYFTSb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYFTSbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:31:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:50065 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYFTSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=M8T9BWk8tz3eyiL9aW1s1UpSpOCYP84MzMQuPS72Xzd0hw8pRqzKr9HeBlbdM74AP/
         kvCGawK047aTaT6CIzAtElGV9TncShUvkvm/8sVHQk37x06NuzFPXl/SRO/guOSqtcRh
         59K1XcZ5nD/Tj1aH578cx3dbr9gmRSNTOpvC8=
To: =?iso-8859-15?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc (fwd)
Date: Fri, 20 Jun 2008 20:48:46 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080620175729.GA3151@ime.usp.br>
In-Reply-To: <20080620175729.GA3151@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806202048.47239.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Did you receive my earlier message (attached here for reference)? I'm
> willing to experiment with the driver a little bit and I hope that the
> information that I have provided so far is helpful to chase the reason
> why the driver doesn't work on PowerPC.

Sorry I have been quite busy with other things.
I have glanced over the register dumps, and there are no obvious endian problems.

The reason most registers are different with the 16bits swapped is the way
rt2x00 sends the register information through debugfs. rt2500usb only has 16bit
registers and the way the information is dumped through debugfs assumes 32bit
registers.

I will go over the real register differences as soon as possible, but as I said,
I am momentarily quite busy with other things. :(

Ivo
