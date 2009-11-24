Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbZKXNXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbZKXNXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZKXNXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:23:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZKXNW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:22:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Sachin Rane" <SRane@alphion.com>
Subject: Re: Need Info about IDE driver
Date: Tue, 24 Nov 2009 14:23:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <846629303ABF174A9EA5BB26D6965A594D5465@MX2.AlphionCorp.local>
In-Reply-To: <846629303ABF174A9EA5BB26D6965A594D5465@MX2.AlphionCorp.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241423.02389.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18gGnO2nlC+ashziLi0hrSXE9eEX4e3+xJ4RPY
 FKU40+6L8xB5uWUmQVPBRfqI22BtvVRzipi7VVjHCdl/NgGNBD
 L5EyEsxRdVIOkNc6mqXkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009, Sachin Rane wrote:
>  
> I am new to  'IDE' Linux driver.
> Before writing this mail I tried to get information from internet but
> couldn't hit the website which can give developer point of view
> information.
>  
> I am going through the code '
> kernel-2.6.16.1-ts.amcc440gx.basic.1/drivers/ide/pci/siimage.c' and user
> manual for 'Sil0680' to understand how the IDE driver works.
> 

Hi Sachin,

To make sure you're now going down the wrong path, please be advised
that the 'IDE' drivers are no longer under active development and
are getting replaced by the 'libata' subsystem. You should be looking
at drivers/ata/pata_sil680.c and possibly stat_sil*.c.

Also, note that 2.6.16 is very old and any work you invest there is
probably wasted, so look at the latest version 2.6.31 or 2.6.32.

	Arnd <><
