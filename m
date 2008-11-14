Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYKNPIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYKNPIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKNPId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:08:33 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:19067 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYKNPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:08:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=BfF8J+mTvmQdhp8twi6mF8oAsw3zYBL8kfeqZdBne79HvrMoKocQxiRK/HEDS7mJCy
         FdD+lM5RDLoO9RwdhNrevh4Y3Q7Od3TNeCJ48ijQrIX5QlA94ecT5AQ6YebULDqrH7xF
         XPRYW4qwlZPr5hqSqd3pwCYR9zu4qQqrhpz18=
Date: Fri, 14 Nov 2008 10:08:20 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/virtex: fix various format/casting printk
	mismatches
Message-ID: <20081114150820.GA20645@yoda.jdub.homelinux.org>
References: <20081114045304.15077.72430.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114045304.15077.72430.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 09:53:04PM -0700, Grant Likely wrote:
>From: Grant Likely <grant.likely@secretlab.ca>
>
>Various printk format string in code used by the Xilinx Virtex platform
>are not 32-bit/64-bit safe.  Add correct casting to fix the bugs.
>
>Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

This fixes the warnings I have been seeing on the ppc40x_defconfig, so:

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

josh
