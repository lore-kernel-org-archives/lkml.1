Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXC1TJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXC1TJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXC1TJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:09:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXC1TIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:08:39 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: tighten kernel image page access rights
Date: Wed, 28 Mar 2007 21:07:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <4607F177.76E4.0078.0@novell.com>
In-Reply-To: <4607F177.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282107.11511.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_HOTPLUG_CPU
> +	/* It must still be possible to apply SMP alternatives. */
> +	if (num_possible_cpus() <= 1)

It would be better to temporarily change the pages where the alternatives
are applied while that is done and keep it otherwise ro

-Andi
