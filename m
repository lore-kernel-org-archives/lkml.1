Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYJALzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYJALzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYJALyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:54:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:39682 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYJALyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=poKOXqv8soSylqPK/Cupqhj486O03SQ5XRx2/NakrRse0Cn74icT3j9MBAKovAb30s
         KQjPKqEsirOV291/501qtcMRn2UZy+m3dKFjQVfakcheCCQSKpsDpPGLX3FRDvk1yf3G
         YKfDEc/qAOXm2vhD+708StdsniPr3r2fcx9DA=
Message-ID: <c68f135e0810010454m70e55181q2c4af659ace6f0b0@mail.gmail.com>
Date: Wed, 1 Oct 2008 13:54:52 +0200
From: "Andrea Merello" <andreamrl@tiscali.it>
Reply-To: andreamrl@tiscali.it
To: "Alex Riesen" <raa.lkml@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Michael Wu" <flamingice@sourmilk.net>,
       "Andrea Merello" <andreamrl@tiscali.it>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: NETGEAR WG111v2 (USB RTL8187): freezes whole system when setup
In-Reply-To: <20080930222723.GA28369@steel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080930222723.GA28369@steel.home>
X-Google-Sender-Auth: 4f4c7e90913ac8cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reporting it.
I'm not currently working on drivers now, sorry, but I hope someone
involved in linux wireless might investigate your problem.

Thanks
Andrea

On Wed, Oct 1, 2008 at 12:27 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> I have an USB wireless card: Netgear WG111v2. It is reported in
> syslog as:
>
>    usb 4-2: Product: NETGEAR WG111v2
>    usb 4-2: Manufacturer: NETGEAR WG111v2
>    usb 4-2: SerialNumber: 000FB5D51ECA
>    phy1: Selected rate control algorithm 'pid'
>    phy1: hwaddr 00:0f:b5:d5:1e:ca, RTL8187vB (default) V1 + rtl8225
>    usbcore: registered new interface driver rtl8187
>
> On ifconfig up, the card always locks up two very different systems: a
> relatively modern P4 desktop and P-MMX laptop with UHCI (ancient Compaq
> Armada 1592DT) which has an OHCI.
>
> The connection is not stable and sometimes the card just stops
> talking to anything outside: the connection is not dropped, but
> nothing works (no ping replies). Up/down interface does not help.
>
> Aside from that there were no ill effects noticed.
>
> I tried 2.6.27-rc7 and -rc8 with no difference.
>
> Reported to bugzilla as
>
>    http://bugzilla.kernel.org/show_bug.cgi?id=11678
>
>
