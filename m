Return-Path: <linux-kernel-owner+w=401wt.eu-S2993088AbXDRTeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993088AbXDRTeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993085AbXDRTeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:34:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:58413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993088AbXDRTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:34:03 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Marat Buharov" <marat.buharov@gmail.com>
Subject: Re: 2.6.20.6 vanilla does't boot
Date: Wed, 18 Apr 2007 15:32:39 -0400
User-Agent: KMail/1.9.5
Cc: "=?utf-8?q?=D0=94=D0=B5=D0=BD=D0=B8=D1=81?=
	=?utf-8?q?_=D0=9A=D0=B8=D1=80=D1=8C=D1=8F=D0=BD=D0=BE=D0=B2?=" 
	<kirjanov@gmail.com>,
       "Marc Donner" <Marc.Donner@dbd-breitband.de>,
       linux-kernel@vger.kernel.org
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com> <a872555b0704122246n7be574e7mc53920d6e446f86@mail.gmail.com> <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com>
In-Reply-To: <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181532.39966.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 02:35, Marat Buharov wrote:
> > [17179569.184000]   >>> ERROR: Invalid checksum
> Seems like you have buggie bios. As the workaround try to start your
> kernel with noacpi parameter.
> Solution: Upgrade the BIOS firmware with the latest version available from the
> manufacturer.

ACPI: OEMB (v001 A M I  AMI_OEM  0x05000504 MSFT 0x00000097) @ 0x7ffae040
>>> ERROR: Invalid checksum
ACPI: MCFG (v001 A M I  OEMMCFG  0x05000504 MSFT 0x00000097) @ 0x7ffa8810

The Invald checksum message refers to the table header that was just printed.
In this case the OEMB  table, which Linux doesn't use.

-Len
