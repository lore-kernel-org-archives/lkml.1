Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbZFQGmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbZFQGmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFQGly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:41:54 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47824 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZFQGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:41:54 -0400
Date: Wed, 17 Jun 2009 08:41:51 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linuxppc-dev@ozlabs.org, Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       raisch@de.ibm.com, linux-kernel@vger.kernel.org,
       ewg@lists.openfabrics.org
Subject: Re: [ewg] Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory
 operations and huge pages
Message-ID: <20090617084151.010562c5@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <adazlc8w45c.fsf@cisco.com>
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
	<adar5xoybwt.fsf@cisco.com>
	<20090616090809.34d162fc@BL3D1974.boeblingen.de.ibm.com>
	<adazlc8w45c.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 09:10:39 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> 
>  > Yeah, the notifier code remains untouched as we still do not allow dynamic
>  > memory operations _while_ our module is loaded. The patch allows the driver to
>  > cope with DMEM operations that happened before the module was loaded, which
>  > might result in a non-contiguous memory layout. When the driver registers
>  > its global memory region in the system, the memory layout must be considered.
>  > 
>  > We chose the term "toleration" instead of "support" to illustrate this.
> 
> I see.  So things just silently broke in some cases when the driver was
> loaded after operations you didn't tolerate?
> 
> Anyway, thanks for the explanation.

Well, things did not break silently. The registration of the MR failed with
an error code which was reported to userspace.

Will you push the patch for .31 or .32?

Thanks,
Alex
