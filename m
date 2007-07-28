Return-Path: <linux-kernel-owner+w=401wt.eu-S938663AbXG1BGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938663AbXG1BGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938353AbXG1BGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:06:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:51188 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938309AbXG1BGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=htXkHgB78O9KWSCUS+3iLwyCvHXRc2CBCzYzI33AtSiHLLTIcK4rZt7bV1Uju6hM0SzeKwUE1SKbgeqIQtPdUUnlJFQDFKaqMUR1e4BxeJQroOA6y0qa5ECs+2DjMLXFzE7C4aN3ooAcxiBbZeKHlCE8pGwEG8sSss/fzwSqQfc=
Message-ID: <92a12cdb0707271806q60fcaa91s77a628b31cd65b4d@mail.gmail.com>
Date: Sat, 28 Jul 2007 02:06:39 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <1185583925.26603.24.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
	 <1185571890.26603.7.camel@daplas>
	 <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
	 <1185578576.26603.16.camel@daplas>
	 <92a12cdb0707271732l1d61f0aajfbd72c62d7ded3b6@mail.gmail.com>
	 <1185583925.26603.24.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:

>
> Is this with commit a66ad56eb2c9644717da4d7f05f971d6786145e3 reverted?
> Reapply this commit again, it might (fingers crossed) correct the color
> problem.
>
> As to your display doubling/quadrupling with bpp 24/32, I don't have any
> answers (no hardware) though it seems to be a framebuffer pitch/display
> width mismatch.
>

Mostly solved the colour problem at 16bpp (black background but pale
blue text - had previously been white). At 32bpp just as before -
oversized and yellow.

At 24bpp much as before too - all against black but two boot logos in
greenish shade and everything doubled up on screen in greenish shade
(ie around half of pixels in console text message on left, around half
in repeat on right).

But certainly better at 16bpp

Can mess about with it later to see if I can get the colours right I suppose.

Adrian
