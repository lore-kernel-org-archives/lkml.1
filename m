Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbZIDVFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbZIDVFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933903AbZIDVFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:05:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933748AbZIDVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:05:23 -0400
Date: Fri, 4 Sep 2009 14:03:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com, m.selhorst@sirrix.com, jmorris@namei.org,
       jbeulich@novell.com
Subject: Re: [PATCH] TPM: Fixup pubek sysfs file
Message-Id: <20090904140325.c592289a.akpm@linux-foundation.org>
In-Reply-To: <adaab1bnvz3.fsf@cisco.com>
References: <20090904045231.GW4973@obsidianresearch.com>
	<adaab1bnvz3.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Sep 2009 22:02:24 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> 
>  > Algorithm: 00 00 00 01
>  > Encscheme: 00 03
>  > Sigscheme: 00 01
>  > Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
>  > Modulus length: 256
> 
> No argument that this fix is an improvement, but what happened to the
> "one value per file" rule for sysfs??

We goofed.  This one snuck through.

It's one of the reasons why I recommend that people cite examples of
the sysfs/procfs output in changelogs.  These things are part of the
kernel ABI and once they go in we cannot change them so we have to get
them right first time.
