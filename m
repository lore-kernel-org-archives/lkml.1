Return-Path: <linux-kernel-owner+w=401wt.eu-S934377AbXKPXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbXKPXsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXKPXse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:48:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35726 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbXKPXsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:48:33 -0500
Date: Fri, 16 Nov 2007 23:46:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin Olsson <mnemo@minimum.se>
Cc: linux-kernel@vger.kernel.org,
       Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Message-ID: <20071116234647.5825b76c@the-village.bc.nu>
In-Reply-To: <473E9290.3040006@minimum.se>
References: <473E815F.30900@minimum.se>
	<20071116213137.6efe3f9e@the-village.bc.nu>
	<473E9290.3040006@minimum.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 3. Run this command:
> 
>     :(){ :|:& };:
> 
> 4. Ubuntu starts to work furiously, after less than a second terminal 
> gets flooded with "low resources" message, 

Set your system with suitable process and user resource limits. Also I'd
suggest setting memory overcommit to strict.

Our default behaviour is relaxed as it is usually the right thing for a
generic desktop box.

Alan
