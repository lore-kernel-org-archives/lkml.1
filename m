Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZFFR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZFFR0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 13:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZFFRZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 13:25:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45527 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZFFRZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 13:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZRKCZgdjaDlS2VwTc37uRR15iOgD9BhEQr7AX0vOWgGRjoxHr0vIVx+yasX0cuFQX4
         OBhK0CDIvy1TGoreuhL1rhUgOhIEjTx8T23Y+1Il/mu8+YTs4HhI0CtTR4AXb4Tml5Es
         5eBbHE1aCp2FmJX7SR2EzdwICZFjtDk+5hj6Q=
From: Florian Fainelli <florian@openwrt.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 8/8] 8250: add Texas Instruments AR7 internal UART
Date: Sat, 6 Jun 2009 19:25:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
References: <200906041622.47591.florian@openwrt.org> <20090604222020.GA14843@alpha.franken.de>
In-Reply-To: <20090604222020.GA14843@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906061925.53839.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Friday 05 June 2009 00:20:20 Thomas Bogendoerfer, vous avez écrit :
> On Thu, Jun 04, 2009 at 04:22:46PM +0200, Florian Fainelli wrote:
> > We discussed that in private, there are a couple of things
> > to fix in order to get 8250 working properly with TI AR7 HW.
> > If you can still merge that bit, this would ease future work, thanks !
>
> I still have a tree here, which works without any changes to the 8250
> serial driver on a TNETD7300 device.

Got to test with defining the UART type as a PORT_16550 and use UPIO_MEM32 
instead of UPIO_MEM.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
