Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZJBK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZJBK0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZJBK0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:26:41 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:2592 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508AbZJBK0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:26:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19141.54587.207559.849751@pilspetsen.it.uu.se>
Date: Fri, 2 Oct 2009 12:26:03 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Nick Piggin <npiggin@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: Work around BIOS bugs by quiescing USB controllers earlier" causes MCEs
In-Reply-To: <20091002073400.GV6327@wotan.suse.de>
References: <20091002073400.GV6327@wotan.suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:
 > Hi,
 > 
 > Your patch db8be50c4307dac2b37305fc59c8dc0f978d09ea is causing my
 > ia64 Altix system to die with an MCE in early boot.

The same commit has been confirmed by two people on the ARM list
to cause boot failures on two different Intel XScale IOP machines.
The machines have serial consoles, but only show

Uncompressing Linux... done. Booting the kernel.

before they hang.
