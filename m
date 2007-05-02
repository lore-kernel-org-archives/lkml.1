Return-Path: <linux-kernel-owner+w=401wt.eu-S2993034AbXEBKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993034AbXEBKfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993043AbXEBKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:35:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:40060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993042AbXEBKf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:35:29 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 02/10] i386 pci: type may be unused
Date: Wed, 2 May 2007 12:35:25 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021235.25993.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 06:28:22 David Rientjes wrote:
> In the case of !CONFIG_PCI_DIRECT && !CONFIG_PCI_MMCONFIG, type is
> unreferened.

The patch didn't compile on i386 defconfig. Fixed now but please
compile test future patches.

-Andi
