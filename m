Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXCaHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXCaHxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXCaHxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:53:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42049 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXCaHxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:53:16 -0400
Date: Sat, 31 Mar 2007 00:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helgehaf@aitel.hist.no>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-Id: <20070331005303.354411f0.akpm@linux-foundation.org>
In-Reply-To: <20070331071220.GA26910@aitel.hist.no>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<20070331071220.GA26910@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 09:12:20 +0200 Helge Hafting <helgehaf@aitel.hist.no> wrote:

> A new error for me:
> 
> loading 2.6.21rc5mm3
> Bios data check successful
> Destination address not 2M aligned
>  -- System halted
> 
> 
> This is using the same lilo that loads 2.6.18rc5mm1 fine.
> x86-64
> 

That's new.  Does changing the value of CONFIG_RELOCATABLE change anything?

Please send the .config.
