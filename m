Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXFYTLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXFYTLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXFYTL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:11:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:46408 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXFYTL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type;
        b=Dsk63qlwpbFAFe3GO5zbNF+EMOIHMqroVtWkQI8ju8efFQBDoIqIiVWMOPdHBzgAt2XIuijedPkqoKHpkFM/VzFGUDKQz0f2+3nmK78I+OvPKVPx3EfhYvHlgm/7jDMoqaF1p2XdcfjhNV/WZ6WKQ2WJP7vMYiSGCHXLIGrhe+k=
Message-ID: <46801362.3040605@gmail.com>
Date: Mon, 25 Jun 2007 21:11:30 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: albertl@mail.com
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: [Fwd: Re: libata and legacy ide pcmcia failure]
Content-Type: multipart/mixed;
 boundary="------------070703090404000903000409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070703090404000903000409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Oops had done a reply instead of a reply to all...


--------------070703090404000903000409
Content-Type: message/rfc822;
 name="Re: libata and legacy ide pcmcia failure.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: libata and legacy ide pcmcia failure.eml"

Message-ID: <467FA93B.6010403@gmail.com>
Date: Mon, 25 Jun 2007 13:38:35 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: albertl@mail.com
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com> <46710CD7.9070901@gmail.com> <467BB7DB.4090004@gmail.com> <467BCF86.8060508@rtr.ca> <467F3EDC.2060002@tw.ibm.com> <467F8B8B.1000006@gmail.com> <467F95D8.6000805@tw.ibm.com>
In-Reply-To: <467F95D8.6000805@tw.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Albert Lee wrote:
> The patch just workarounds the "lost irq" problem by polling; not real
> fix. We still need to find out why irq is lost per Mark's comment:
>
> "This proves that the device does work correctly in most respects
> except for interrupt delivery.  The status bits are working and
> it can be probed for, configured, and used."
>
> "So, next step might be to try and understand the interrupt mis-delivery
> problem some more.   I've lost the history of the original issue,
> but we now know that everything except the actual interrupt seems good."
>
> I am not familiar with the PCMCIA interrupt delivery. It seems the
> "Dazzle 4in1 Card Adapter" works under windows but somehow lost irq
> under both IDE and libata. Maybe Alan/Bart or the PCMCIA developers
> know better...
> --
> albert

I see. So this is not the ideal fix for this problem. Anything else I 
can do to debug the irq lost issue? perhaps add some debug to the pcmcia 
code?

For what its worth, I compiled a clean 2.6.22-rc5 with just the 
pio_polling patch added, and that allows me to mount the device without 
any errors in syslog. So the 
disable-dev_init_param-and-setxfermode-for-CFA.patch is not needed.



--------------070703090404000903000409--
