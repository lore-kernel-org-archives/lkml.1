Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXGYCgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXGYCgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 22:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbXGYCf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 22:35:56 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:43255 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXGYCfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 22:35:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Tue, 24 Jul 2007 20:34:42 -0600
User-Agent: KMail/1.9.6
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "=?iso-8859-1?q?S=E9bastien?= =?iso-8859-1?q?_Dugu=E9?=" 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <46A65D7D.6040409@garzik.org> <86802c440707241333qcaac27fw8a265098cd164be8@mail.gmail.com>
In-Reply-To: <86802c440707241333qcaac27fw8a265098cd164be8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707242034.42679.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 02:33:05 pm Yinghai Lu wrote:
> I have a system that has the same problem, and it turns out that FW
> missed PNP0501 is DSDT for uart. and add that it into DSDT works well.

Is this FW that has been shipped?  Can you give any more details,
like DMI info and a copy of the DSDT?  We can't expect users to
upgrade their firmware or use a custom DSDT.

Bjorn
