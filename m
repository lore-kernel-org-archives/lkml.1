Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZJZUkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZJZUkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZJZUkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:40:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:13537 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbZJZUko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="461538206"
Date: Mon, 26 Oct 2009 13:40:45 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/7] vsprintf: fix io/mem resource width
Message-ID: <20091026134045.39a92084@jbarnes-g45>
In-Reply-To: <20091006213329.4272.6694.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
	<20091006213329.4272.6694.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Oct 2009 15:33:29 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> The leading "0x" consumes field width, so leave space for it in
> addition to the 4 or 8 hex digits.  This means we'll print
> "0x0000-0x01df" rather than "0x00-0x1df", for example.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied this series to my linux-next tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
