Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZI0CEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZI0CEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 22:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZI0CEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 22:04:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:59916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZI0CEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 22:04:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,458,1249282800"; 
   d="scan'208";a="497271060"
Subject: Re: [git pull request] ACPI & driver patches for Linux-2.6.32-rc0
From: Lin Ming <ming.m.lin@intel.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <d3f22a0909261902o5e48c2a0lab56fca21edf8c5b@mail.gmail.com>
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain>
	 <4ABCB2CA.4020709@mandriva.org>
	 <d3f22a0909261902o5e48c2a0lab56fca21edf8c5b@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 09:55:03 +0800
Message-Id: <1254016503.17697.21.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This gets my laptop flooding logs with:

Hi, 

Could you do a bisect?

Thanks
Lin Ming

> 
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> > ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20090903/evregion-424)
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.GBST] (Node ffff88013f81c5e0), AE_TIME
> > ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_.BAT0._BST] (Node ffff88013f81c720), AE_TIME
> > ACPI Exception: AE_TIME, Evaluating _BST (20090903/battery-393)
> 
> --
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

