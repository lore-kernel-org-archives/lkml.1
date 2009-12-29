Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbZL2RPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbZL2RPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZL2RP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:15:29 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:43358 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZL2RP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CDwwWANaFTBOQMAXswxU3BjNMX+Rnji36aaA4D7F8ohiIX/TRNR1j4b5y4bE+qUw+k
         hVm39T4bjZY2/gn6tbMBBhnhtMCIAANQK4F4Waglq6cDkr6gK+Pt/jqOuSp9OhF15f7a
         tHNCqrwUZ80WLG73limIOoOcR6rJyvG8xUFas=
MIME-Version: 1.0
In-Reply-To: <srmJ8vMxKPH.A.nSB.IwhOLB@chimera>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.nSB.IwhOLB@chimera>
Date: Tue, 29 Dec 2009 11:15:27 -0600
Message-ID: <51f3faa70912290915s41d801c5y47f4fea914055274@mail.gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata 
	controller
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 9:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14922
> Subject         : 2.6.32 seemed to have broken nVidia MCP7A sata controller
> Submitter       : Mike Cui <cuicui@gmail.com>
> Date            : 2009-12-19 6:13 (11 days old)
> References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> Handled-By      : Jeff Garzik <jeff@garzik.org>
>                  Robert Hancock <hancockrwd@gmail.com>

Yes, FPDMA auto-activate optimization was introduced for AHCI in
2.6.32 and it appears it doesn't work quite right with either the
reporter's AHCI controller or their drive. I believe they were going
to try the drive with an Intel controller to see if it worked there.

It would be useful if we could get other success/failure reports with
either the particular drive, WDC WD800ADFS-75SLR2 (or at least other
WD Raptor ADFS-series) on other AHCI controllers, or other drives
which have AA support on the MCP7A chipset. One of the two needs
blacklisting for AA support. I'm leaning towards the controller since
other WD drives with AA support work fine on Intel AHCI.
