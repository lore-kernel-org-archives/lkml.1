Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbZADSFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbZADSFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZADSFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:05:34 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42273 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZADSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:05:33 -0500
Date: Sun, 4 Jan 2009 11:05:15 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Message-ID: <20090104180515.GD2002@parisc-linux.org>
References: <20090104092430.7ffd2c41@infradead.org> <20090104092940.11943797@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104092940.11943797@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 09:29:40AM -0800, Arjan van de Ven wrote:
> >From 2087b546abddced50fa73ea9a71b5a040ae1026e Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make scsi probes asynchronous
> 
> This patch makes part of the scsi probe (which is mostly device spin up and the
> partition scan) asynchronous. Only the part that runs after getting the device
> number allocated is asynchronous, ensuring that device numbering remains stable.

Is this really a big win?  Were you using the async scsi scan code
already?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
