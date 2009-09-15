Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZIOGY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZIOGY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZIOGYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:24:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60016 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbZIOGYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:24:54 -0400
Date: Tue, 15 Sep 2009 16:24:57 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Check for unsupported relocs when using
 CONFIG_RELOCATABLE
Message-ID: <20090915062457.GG10656@bilbo.ozlabs.org>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linuxppc-dev list <linuxppc-dev@ozlabs.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1252994222.8375.201.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1252994222.8375.201.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:57:02PM +1000, Benjamin Herrenschmidt wrote:
 
> diff --git a/arch/powerpc/relocs_check.pl b/arch/powerpc/relocs_check.pl
> new file mode 100755
> index 0000000..215e966
> --- /dev/null
> +++ b/arch/powerpc/relocs_check.pl
> @@ -0,0 +1,57 @@
> +#!/usr/bin/perl
> +
> +# Copyright © 2009 IBM Corporation
> +
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License
> +# as published by the Free Software Foundation; either version
> +# 2 of the License, or (at your option) any later version.
> +
> +# This script checks the relcoations of a vmlinux for "suspicious"
> +# relocations.
> +
> +use strict;
> +use warnings;
> +
> +if ($#ARGV != 1) {
> +	print "$#ARGV\n";

Ooops that line should have been taken out.  Sorry.

Yours Tony
