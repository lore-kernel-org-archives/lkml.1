Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbXBED4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbXBED4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 22:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXBED4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 22:56:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:44868 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXBED4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 22:56:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A2lovrWI8qOlzLWQQKuZnCIdZ6IpHa5EfeM9TPpEubi8xpZlhwn/yi/YP4bxtu7D0emsgrtBu3MhTVtYx1XTwTs6r5pwyv/bbpeIMot8KxOKh7ZFhTItni/ADQPK7RELExgY+8SQRFKU+lMPSWHmD4DHu/1lNIHQsyhV0gt82Vo=
Message-ID: <3877989d0702041956h1a423cafy40aef4aa4d8a1dc9@mail.gmail.com>
Date: Mon, 5 Feb 2007 11:56:19 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Keenan Pepper" <keenanpepper@gmail.com>
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic works perfectly
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the dmesg, I found a problem NOT relative to the PATA driver.
I would like to know if cpu freq driver works? If not, please enter a
acpi bug on bugzilla.kernel.org.

"[   17.368000] ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT,
Index (0FFFFFFFD) is beyond end of object [20060707]
[   17.368000] ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU1._PSS] (Node c1468ba8), AE_AML_PACKAGE_LIMIT
[   17.368000] ACPI Exception (acpi_processor-0235):
AE_AML_PACKAGE_LIMIT, Evaluating _PSS [20060707]
[   17.368000] ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT,
Index (0FFFFFFFD) is beyond end of object [20060707]
[   17.368000] ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU2._PSS] (Node c14689f0), AE_AML_PACKAGE_LIMIT
[   17.368000] ACPI Exception (acpi_processor-0235):
AE_AML_PACKAGE_LIMIT, Evaluating _PSS [20060707]
"

On 2/4/07, Keenan Pepper <keenanpepper@gmail.com> wrote:
> I just upgraded the kernel on my System76 Gazelle laptop (basically an
> ASUS Z62FP without the Microsoft tax) and the hard drive began
> freezing every few minutes. I blacklisted ata_piix and the problem
> went away, so that really narrows down where the bug has to be. Here's
> the relevant part of the dmesg:
>
> [  924.000000] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> [  924.000000] ata1.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0
> cdb 0x25 data 8 in
> [  924.000000]          res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask
> 0x4 (timeout)
> [  931.004000] ata1: port is slow to respond, please be patient (Status 0xd0)
> [  954.028000] ata1: port failed to respond (30 secs, Status 0xd0)
> [  954.028000] ata1: soft resetting port
> [  954.380000] ata1.00: configured for UDMA/100
> [  954.560000] ata1.01: configured for UDMA/33
> [  954.560000] ata1: EH complete
>
> Complete dmesg and lspci -vvx are attached; please CC me because I'm
> not subscribed. My sincere apologies if this is already fixed in the
> main kernel.
>
> Keenan Pepper
>
>
