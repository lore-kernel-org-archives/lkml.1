Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXEIU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXEIU0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXEIU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:26:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36751 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXEIU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:26:25 -0400
Date: Wed, 9 May 2007 15:26:21 -0500
To: matthew@wil.cx
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Message-ID: <20070509202621.GA4452@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420204720.GM31947@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

I had been hoping these patches might make it into 2.6.22,
... this is a nag note; please forward upstream.

--linas

On Fri, Apr 20, 2007 at 03:47:20PM -0500, Linas Vepstas wrote:
> 
> Implement the so-called "first failure data capture" (FFDC) for the
> symbios PCI error recovery.  After a PCI error event is reported,
> the driver requests that MMIO be enabled. Once enabled, it 
> then reads and dumps assorted status registers, and concludes
> by requesting the usual reset sequence.
> 
> (includes a whitespace fix for bad indentation).
> 
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
