Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbYBAKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbYBAKTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbYBAKTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:19:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:59953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615AbYBAKTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:19:19 -0500
From: Stefan Roese <sr@denx.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] pci: Fix bus resource assignment on 32 bits with 64b resources
Date: Fri, 1 Feb 2008 11:18:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20071210063216.89DBBDDE1E@ozlabs.org>
In-Reply-To: <20071210063216.89DBBDDE1E@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011118.57610.sr@denx.de>
X-Provags-ID: V01U2FsdGVkX18ByycwN7g/2pnvsFUrVs5jiIlEs40xasAOawV
 WEN9zaGKCWHWV2gMGrx64GPOOmU9LS7xAPCm27jpkKha++dFJn
 p4uftsnQaGxbJfb7cjweqUE+xVVMKQK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007, Benjamin Herrenschmidt wrote:
> The current pci_assign_unassigned_resources() code doesn't work properly
> on 32 bits platforms with 64 bits resources. The main reason is the use
> of unsigned long in various places instead of resource_size_t.
>
> This fixes it, along with some tricks to avoid casting to 64 bits on
> platforms that don't need it in every printk around.
>
> This is a pre-requisite for making powerpc use the generic code instead of
> its own half-useful implementation.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Checking Linus's latest git repository, it seems this patch (and the 2nd from 
this series) hasn't been applied till now. This is just a reminder, that it 
gets in in this merge-window.

Thanks.

Best regards,
Stefan
