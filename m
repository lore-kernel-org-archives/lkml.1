Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZKCKm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZKCKm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZKCKm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:42:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43348 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbZKCKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:42:25 -0500
Date: Tue, 3 Nov 2009 10:43:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: Re: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20091103104352.3a460ae9@lxorguk.ukuu.org.uk>
In-Reply-To: <20091103003511.GL7768@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - Move the user space data buffer and related goop into a
>   struct tpm_file, create one struct tpm_file per open file.

Is that really sufficient ?

You can open a file once, dup it (or inherit it and get multiple callers
from the same file handle. Ditto consider threated apps

Alan
