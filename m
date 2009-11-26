Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZKZDAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZKZDAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZKZDAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:00:43 -0500
Received: from ozlabs.org ([203.10.76.45]:33247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZKZDAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:00:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19213.61204.591278.856459@drongo.ozlabs.ibm.com>
Date: Thu, 26 Nov 2009 13:59:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 2/3] sysfs cpu probe/release files
In-Reply-To: <4B0CD8D5.8050803@austin.ibm.com>
References: <4B0CD70F.6090600@austin.ibm.com>
	<4B0CD8D5.8050803@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> In order to support kernel DLPAR of CPU resources we need to provide an
> interface to add (probe) and remove (release) the resource from the system.
> This patch Creates new generic probe and release sysfs files to facilitate
> cpu probe/release.  The probe/release interface provides for allowing each
> arch to supply their own routines for implementing the backend of adding
> and removing cpus to/from the system.
> 
> This also creates the powerpc specific stubs to handle the arch callouts 
> from writes to the sysfs files.
> 
> The creation and use of these files is regulated by the 
> CONFIG_ARCH_CPU_PROBE_RELEASE option so that only architectures that need the
> capability will have the files created.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: Paul Mackerras <paulus@samba.org>
