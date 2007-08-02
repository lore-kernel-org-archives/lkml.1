Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXHBUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXHBUMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbXHBUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:12:13 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:5149 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbXHBUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QqOMbPDvPGQI2/Hz9jtrTIc6pFmLql7kpYapoN8p6KZTRGFJOlGABmW1+MbJ5J2p7+Ict9REue3RvsxJq+YLOsLhZhT++BDNvNIG5jfA+rNQmllWkrkWLepxfH9WyQSKdxGpw0/K9moW69kRRwjwbLaZCgMl+JkzGGocDHs+Hlo=
Message-ID: <9a8748490708021312g4338d84w1ca038fb7fc104c7@mail.gmail.com>
Date: Thu, 2 Aug 2007 22:12:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: gcc fixed size char array initialization bug - known?
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070802201030.GP21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
	 <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
	 <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
	 <20070802201030.GP21089@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Thu, Aug 02, 2007 at 10:03:03PM +0200, Jesper Juhl wrote:
> > I believe Guennadi's point is that gcc does not warn about it in the
> > case of  c[4] = "0123"; but only in the case of c[4] = "01234" - so if
> > we do have such initializations in the kernel we may have some bugs
> > hiding there that gcc doesn't warn us about.
>
> Who said it's a bug?  Or that all arrays of char have to contain '\0'
> anywhere in them?
>
I was simply trying to explain what I thought Guennadi meant. I was
not commenting on whether or not there's a bug there.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
