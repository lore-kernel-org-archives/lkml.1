Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbXG0SjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbXG0SjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbXG0Si6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:38:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:8191 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbXG0Si5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TJl6FBAg/tjo9IRDob4JaBzZDIM27S9ufnBQdLNTH269NP6xxtEJXuPWIu5uHoZdS9oclPmPRWNPlvEYYavkN3vmXdcRXA7YzFajy8JD+pDd1ZHD/n2fXHsqoDnRUHw/R0+pWC6Nfxl6sSlYA/yxvKRYQ9NGJVf3HzhQfTUhHTU=
Message-ID: <86802c440707271138k822077cl9dd9995ee2b9c7dd@mail.gmail.com>
Date: Fri, 27 Jul 2007 11:38:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Shaohua Li" <shaohua.li@intel.com>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
In-Reply-To: <200707271217.00164.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com>
	 <1185416466.31345.1.camel@sli10-conroe.sh.intel.com>
	 <200707271217.00164.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 25 July 2007 08:21:06 pm Shaohua Li wrote:
> That doesn't help with Yinghai's PCI root ordering issue, of course.

I could
sort the acpi_pci_roots before using it, in acpi_pci_register_driver()

YH
