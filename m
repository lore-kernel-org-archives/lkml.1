Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXGXUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXGXUdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXGXUdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:33:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:63259 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGXUdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E/GcbIEWWIDswcl0xfGlZ2j7Ix5N60pq8sO9JC8JA5h0zE2GQJovL88n/QpUbwQ71u2O9OynW1T9ViQCcSXs9UrqIjjEAWsSEqmwY9gdn/VZ5alvtO9x0Aeb37KmgxG2w9v7i+qe+/6+HQOUE+tBrwolc/pJeKzgVOsp3vOt4no=
Message-ID: <86802c440707241333qcaac27fw8a265098cd164be8@mail.gmail.com>
Date: Tue, 24 Jul 2007 13:33:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?ISO-8859-1?Q?S=E9bastien_Dugu=E9?=" <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <46A65D7D.6040409@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	 <46A63BC3.3050208@garzik.org>
	 <Pine.LNX.4.64N.0707241914060.17807@blysk.ds.pg.gda.pl>
	 <200707241353.57458.bjorn.helgaas@hp.com>
	 <46A65D7D.6040409@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Jeff Garzik <jeff@garzik.org> wrote:
>
> You seem to be missing that ignoring BIOS is often a VERY GOOD thing,
> that has served us well many many times in the past.
>
I have a system that has the same problem, and it turns out that FW
missed PNP0501 is DSDT for uart. and add that it into DSDT works well.

Or we can add some DMI check up, to enable legacy_serial for old BIOS
before some date point?

YH
