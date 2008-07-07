Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYGGVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYGGVLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYGGVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:11:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:22315 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYGGVLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=Q/TTxHIRM+3zSX6MtnMfuwQEv4gv7uWAeEB9+isKHCVQuWBHP0c87MOfx2v/2rTbn1
         LsTumdPOEOT7tG9Jjt/NtnzNbVcyVsT3T2UbCKGrDKx5ll9NMYGxGCqSbALjUnAQ+DeM
         0f0/4kLFQaib3PeHwvAdcIq4Tg3bnvIo+cCmU=
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:19:44 +0200
User-Agent: KMail/1.9.9
Cc: rt2400-devel@lists.sourceforge.net,
       "Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072308.57529.IvDoorn@gmail.com> <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
In-Reply-To: <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807072319.44733.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008, Stefanik Gábor wrote:
> On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Check if the arc4 and ecb modules are loaded before loading mac80211 & rt2500pci.
> >
> > Ivo
> 
> Shouldn't we make mac80211 depend on arc4 and ecb?

They do depend on those modules, but for some reason they
are not always automatically loaded when the mac80211 module is loaded.

Ivo
