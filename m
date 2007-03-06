Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXCFPhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXCFPhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965157AbXCFPhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:37:47 -0500
Received: from [81.2.110.250] ([81.2.110.250]:34950 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965155AbXCFPhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:37:46 -0500
Date: Tue, 6 Mar 2007 16:41:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Surya <surya.prabhakar@wipro.com>
Cc: mulix@mulix.org, linux-kernel@vger.kernel.org,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Subject: Re: [kj]patch7:replace pci_find_device in sound/oss/trident.c
Message-ID: <20070306164149.36e3b855@lxorguk.ukuu.org.uk>
In-Reply-To: <1173175287.32705.5.camel@bluegenie>
References: <1173175287.32705.5.camel@bluegenie>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 15:31:27 +0530
Surya <surya.prabhakar@wipro.com> wrote:

> Hi,
>  Cleanup of pci_find_device to pci_get_device in sound/oss/trident.c
> Applies and compiles clean to latest Linus tree. Not tested!


Thanks. 

I would move the pci_dev_put inside the if as well (the variable is only
used in the ALi section so could itself also be moved), but the fix
appears correct.

Alan
