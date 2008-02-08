Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbYBHWmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbYBHWmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbYBHW2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:28:22 -0500
Received: from hermes.cs.kuleuven.ac.be ([134.58.40.3]:39567 "EHLO
	hermes.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247AbYBHW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:28:20 -0500
Message-ID: <47ACD72C.1080904@huygens.biz>
Date: Fri, 08 Feb 2008 23:26:52 +0100
From: Christophe Huygens <xtof@huygens.biz>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Cardbus/Yenta/PCI/2.6.24 help
References: <47AAD92D.7040601@huygens.biz>
In-Reply-To: <47AAD92D.7040601@huygens.biz>
Content-Type: multipart/mixed;
 boundary="------------080003040501080305040305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080003040501080305040305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christophe Huygens wrote:
> Hi,
>
> I have a problem getting a PCI to Cardbus adapter to work on a dell
> 1550 server. I have been truying for days to get this going but
> I cannot figure out what is wrong. As far as I understand, all
> should be ok in terms ok irqs, and resource windows., PCI..
> This machine has 2G memory and 2 CPUs.
> Running 2.6.22-14-generic, same problem on 2.6.24.
>
> But upon card insertion... nil happens. PCI slot, adapter
> and cards are ganuaranteed healthy.
>
> None of the kernel boot options help imho.
>
> Yenta reports a troublesome (?) socket status:
>
> [  170.575520] Yenta: CardBus bridge found at 0000:02:06.0 [0000:0000]
> [  170.707652] Yenta: ISA IRQ mask 0x0000, PCI irq 16
> [  170.707708] Socket status: ffffffff
>
> Thanks for any assistance, I am running out of steam here!
> Attached lspci, dmesg, io*
>
> Christophe
I finally was able to test this with Windows XP (ouch) and it yes it 
does work.
So either Cardbus or PCI has an issue

Christophe


-- 
------------------------------------------------------------------------

This e-mail and any attached files are confidential and may be legally privileged. If you are not the addressee, any disclosure, reproduction, copying, distribution, or other dissemination or use of the transmitted information is strictly prohibited. If you have received this transmission in error please notify P.S. 23 immediately and then delete this e-mail.
P.S. 23 does not accept liability for the correct and complete transmission of the information, nor for any delay or interruption of the transmission, nor for damages arising from the use of or reliance on the information, nor for confidentiality of the information sent using this channel. The sender or recipient of these messages agrees that they may be read by other P.S. 23 employees than the official recipient or sender in order to ensure the continuity of work-related activities and allow supervision thereof.

------------------------------------------------------------------------

Huygens Consulting
a division of P.S. 23 BVBA
ir. Christophe Huygens
xtof@huygens.biz

BTW - BE - 0479.947.684 - RPR Leuven
Kroegberg 3 B-3000 Leuven
www.huygens.biz
phone +32 496 47 55 64


--------------080003040501080305040305
Content-Type: text/x-vcard; charset=utf-8;
 name="xtof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xtof.vcf"

begin:vcard
fn:Christophe Huygens
n:Huygens;Christophe
org:Huygens Consulting, P.S. 23 BVBA
adr:;;Kroegberg 3;Leuven;;3000;Belgium
email;internet:xtof@huygens.biz
tel;cell:+32 496 47 55 64
x-mozilla-html:FALSE
url:www.huygens.biz
version:2.1
end:vcard


--------------080003040501080305040305--
