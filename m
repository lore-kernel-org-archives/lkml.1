Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbXB0RjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbXB0RjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXB0RjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:39:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:14492 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXB0RjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:39:05 -0500
Date: Tue, 27 Feb 2007 09:36:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, Torben.Mathiasen@hp.com
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Message-Id: <20070227093623.9c54f1d3.randy.dunlap@oracle.com>
In-Reply-To: <45E46976.6060600@freescale.com>
References: <45E46976.6060600@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 11:25:10 -0600 Timur Tabi wrote:

> Hi,
> 
> (Email to device@lanana.org bounces, so I'm sending this to lkml instead.)

cc: to Torben


> I'm working on a UART device driver for the Freescale PowerPC QUICCEngine, which
> is a replacement for the CPM.  Since the QE is basically "CPM v3", and you can't
> have a CPM and a QE on the same board, I figure that they can share the same
> minor numbers.
> 
> I've attached a patch that adds these entries to major number 204.  Please not
> that there's a small typo for /dev/ttyCPM5, and I've fixed that in the patch as
> well.
> 
> Please let me know if my proposal/patch is acceptable, and if not, what changes
> you want me to make.  Thanks.
> 
> patch:
> 
> Fixed a typo with /dev/ttyCPM5.  Added entries for /dev/ttyQE0-3.  The QE
> is a replacement for the CPM, so they can share the same minor numbers.
> 
> --- devices-2.6+.txt	2007-02-22 13:37:18.000000000 -0600
> +++ devices-2.6+.new	2007-02-22 13:42:50.000000000 -0600
> @@ -2770,7 +2770,10 @@
>   		 45 = /dev/ttyMM1		Marvell MPSC - port 1
>   		 46 = /dev/ttyCPM0		PPC CPM (SCC or SMC) - port 0
>   		    ...
> -		 47 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5
> +		 49 = /dev/ttyCPM5		PPC CPM (SCC or SMC) - port 5
> +		 46 = /dev/ttyQE0		PPC QE (UCC) - port 0
> +		    ...
> +		 49 = /dev/ttyQE3		PPC QE (UCC) - port 3
>   		 50 = /dev/ttyIOC0		Altix serial card
>   		    ...
>   		 81 = /dev/ttyIOC31		Altix serial card
> 
> 
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
