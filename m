Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYCZXJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYCZXJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYCZXJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:09:06 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20437 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYCZXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:09:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [patch 00/37] PNP resource_table cleanups
Date: Wed, 26 Mar 2008 17:13:00 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080326171058.099442579@ldl.fc.hp.com> <200803261842.11023.lenb@kernel.org>
In-Reply-To: <200803261842.11023.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261713.03248.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 04:42:10 pm Len Brown wrote:
> i386:
> 
> #1 errs.ACPI.ACPI_DEBUG.ACPI_PROCFS.HIBERNATION.X86_LOCAL_APIC.X86_IO_APIC
> Cleaning...Building...
> ERROR: "pnp_get_resource" [sound/oss/sb.ko] undefined!
> ERROR: "pnp_get_resource" [sound/oss/ad1848.ko] undefined!

Oops, sorry, I forgot to export pnp_get_resource().  I'll post an
updated patch as a response to the original.  Is that easy for you
to handle, Len?  If not, let me know what you'd prefer.

Bjorn

