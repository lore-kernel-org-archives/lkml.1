Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXGRMPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXGRMPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXGRMP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:15:26 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:30612 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbXGRMPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YREkKgD4/xwulmm0wmjrzssHLNhTmMCKtAniJd+dT3uAsMjVIDVQ2LCJfvl8D4N6ZCPiHWUx/I2a8AhT2Kf9rectfWvsx0zICbGKIIUUUbrHe6Q5mXeceDtc9N5lh84NuhEIP33BvGWieK4U/ZlQHRzpXPMEC+sZ2jiAftoPb6Y=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707181342.00647.a1426z@gawab.com>
References: <200707181342.00647.a1426z@gawab.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 20:15:17 +0800
Message-Id: <1184760917.4523.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 13:42 +0300, Al Boldi wrote:
> Geert Uytterhoeven wrote:
> > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> Is there any technical reason why vesafb shouldn't support non-BIOS modes?
> 

vesafb can only use modes included by the vendor in the card's BIOS. The
mode table contains standard modes defined by VESA, and perhaps
vendor-defined custom modes. However, the mode ID of custom modes varies
from card to card, so you have to 'probe' the BIOS first for the list of
modes and their associated ID.  X + the 'vesa' driver does that probe,
and so does the lrmi tool vbetest.
 
So, one cannot just set any mode, unless that mode is already defined in
the BIOS mode table. In VBE 3.0, you might be able to choose an
arbitrary vertical refresh rate, but that's the best mode tuning you can
do with the video BIOS. 

Tony



