Return-Path: <linux-kernel-owner+w=401wt.eu-S965062AbXBUAQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062AbXBUAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXBUAQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:16:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56737 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965062AbXBUAQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:16:56 -0500
Date: Wed, 21 Feb 2007 01:20:31 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070221012031.7ddfa8dd@lxorguk.ukuu.org.uk>
In-Reply-To: <20070220214716.GA3690@mail.muni.cz>
References: <20070220214716.GA3690@mail.muni.cz>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 22:47:17 +0100
Lukas Hejtmanek <xhejtman@mail.muni.cz> wrote:

> Hello,
> 
> introducing SATA ACPI does not work for me (I've filled the bug
> report: http://bugzilla.kernel.org/show_bug.cgi?id=8046) beside those error
> messages, IDE performance is decreased. libata.noacpi=1 option works ok but
> the performance is still slightly degraded (about 10%).

The performance degradation appears unrelated to the ACPI errors. If you
ignore the ACPI errors something has broken ata_piix cable detection.

Alan
