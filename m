Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZF2Q1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZF2Q1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbZF2Q1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:27:23 -0400
Received: from ey-out-1920.google.com ([74.125.78.146]:40507 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZF2Q1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i2IXsN9VQNksRGSzYDXJ6XN7uH6bSMOwVTw2q0sMLSCPxIZPB4IntOvptHpnhpl0ts
         GnDtVQHkABjpSvvH6GrXs1GfAmJHTC41WmIcWkTo86mGGK1t8HlG/tLwUrWYVaCSVoHn
         euGFdxLQArHsWQNxhNHsuJh28IwOy2NLvKVuA=
MIME-Version: 1.0
In-Reply-To: <20090629094658.GE11855@sirena.org.uk>
References: <1246122592.3727.20.camel@brutus>
	 <20090629094658.GE11855@sirena.org.uk>
Date: Mon, 29 Jun 2009 19:27:24 +0300
Message-ID: <800a98740906290927q5469f17fpcd74295e7ce40fb0@mail.gmail.com>
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
From: Ilya Petrov <ilya.muromec@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> Depending on the power management capabilities of the CODEC it may be
> better to support at laest the headphone insert/removal via the audio
> driver as a jack to allow automatic management of the power for the
> relevant paths within the CODEC.

we need to control this manually from userspace - for example, even with
headphone plugged in ringtone should be played via speaker.



-- 
 wbr, Ilya
 ICQ: none, Jabber: ilya.muromec@jabber.ru
