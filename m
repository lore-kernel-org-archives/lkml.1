Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXDBHuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXDBHuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXDBHuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:50:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:29509 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXDBHuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mBhhVJyGETqnhJA5qFuzCW4CRF8YFIuFAI2SnLHamUG5eZV9apWCwxA8pQgWMVR77clQGl2irWPNDjxv3lAF7EUJ/kgAY2NW1ZcdzEOu9xhKdTf8YNLMmXyzA2sKyzbw0e3iQSHiR+ci/PXIQqKvgmvhG1yAesXBfaNSW6vYFyo=
Subject: Re: [PATCH 2/16] vt-pure-colors.diff
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704020902200.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704012002330.12316@yvahk01.tjqt.qr>
	 <1175496592.4614.9.camel@daplas>
	 <Pine.LNX.4.61.0704020902200.1245@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 15:50:41 +0800
Message-Id: <1175500241.4614.23.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 09:04 +0200, Jan Engelhardt wrote:
> On Apr 2 2007 14:49, Antonino A. Daplas wrote:
> >
> >Not too sure about this, the default palette is based on ANSI/ECMA
> >standards (at least for the first 8 colors). Also, this will have subtle
> >effects on the 16-color logo. Since your first patch already allows us
> >to change the palette, let's leave the default alone.
> 
> Ok.
> But to note: xterm and anything graphical (including MS Windows)
> uses the anti-pale color (255,0,0) instead of (255,170,170).

Actually, what threw me off was index 4 in default_blu, which has a
value of 0x90.  This looks weird to me, but I guess that is a typo. I
really have nothing against using 0, 0, 255 instead of 170, 170, 255 in
the intense version of the first 8.

Tony 


