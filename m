Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbZJHVkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbZJHVkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZJHVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:40:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:51756 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZJHVkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=J9hDyuFC9r8BVl2ikGHCQ7V1dIt2gfSOrFhCcAAHKl+VmM2l52SznH1YN70BCQRmoU
         q3jS+hmKY1XiojUeqsrGnqg//JVKiUsw9Z24CQ1xpbmnAAVqk7TDuGTSlmUKlKFsZXsc
         4Bt7+K3XE/1Gf0VxevDnzt1QkANvavf8bF3MY=
MIME-Version: 1.0
In-Reply-To: <BAY138-W981A223FAD78C301641E6E5CC0@phx.gbl>
References: <BAY108-F18507D362F5105C57CCC2FE59E0@phx.gbl> <20070214064427.GA15497@kroah.com> 
	<20091008162203.GA13403@kroah.com> <BAY138-W981A223FAD78C301641E6E5CC0@phx.gbl>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 8 Oct 2009 17:38:43 -0400
Message-ID: <3e8340490910081438g36c2a9c4r461c7a04234a7008@mail.gmail.com>
Subject: Re: Sample PCI Linux Device Driver
To: mankan srinivas <s_mankan@hotmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 2:58 PM, mankan srinivas <s_mankan@hotmail.com> wrote:
>
>  <BAY138-W201EAB14A34CDEFC5AFFCBE5CC0@phx.gbl>
>
>
>  <20091008162203.GA13403@kroah.com>
> Content-Type: text/plain; charset="iso-8859-1"
> Content-Transfer-Encoding: quoted-printable
> MIME-Version: 1.0

First, please fix your mail client - it's munging your mails rather
badly, as you can see.

> Hello=2C
> =20
> I am working on developing PCI based Linux Device Driver. Could you please =
> send me few sample code. I am looking for the code which has more informati=
> on about low-level driver code talks to the hardware. Any real example code=
>  is greatly appreciated.

The entire linux kernel is open source - just look under drivers/ for
plenty of example code. If you're stuck, a 'grep linux/pci.h -R
drivers' should find you PCI drivers. (Note that drivers/pci contains
pci core code, which is probably not what you want)
