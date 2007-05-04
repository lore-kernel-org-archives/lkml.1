Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXEDOH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXEDOH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXEDOH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:07:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbXEDOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:07:57 -0400
Date: Fri, 4 May 2007 16:07:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Per-CPU data as a structure
Message-ID: <20070504140753.GA4344@one.firstfloor.org>
References: <16C35E62-A26F-49FC-9CD8-7BADFCD97BA5@ac.upc.edu> <p73ps5hx1t2.fsf@bingen.suse.de> <463AF095.30406@ac.upc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463AF095.30406@ac.upc.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * percpu provides a mechanism to define variables that are specific to 
> each
> + * CPU in the system.
> + *
> + * Each variable is defined as an independent array of NR_CPUS elements.

The independent array term seems misleading to me. There isn't really
an array anywhere. Perhaps explain it in more details.

If you write documentation please write it in Kerneldoc format so 
that it can be automatically extracted. See
Documentation/kernel-doc-nano-HOWTO.txt

-Andi


