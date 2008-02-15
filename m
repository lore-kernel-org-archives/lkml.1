Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbYBOIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbYBOIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYBOIjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:39:07 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52029 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753192AbYBOIjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:39:06 -0500
Date: Fri, 15 Feb 2008 09:38:44 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, shannon.nelson@intel.com, olof@lixom.net,
       yur@emcraft.com
Subject: Re: [PATCH 0/4] async_tx: fix dependency handling and related
 cleanups
Message-ID: <20080215093844.61917039@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
References: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 00:02:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Dan Williams (4):
>       iop-adma: remove the workaround for missed interrupts on iop3xx
>       async_tx: kill ->device_dependency_added
>       async_tx: fix multiple dependency submission
>       async_tx: checkpatch says s/__FUNCTION__/__func__/g

All of the above changes are fine with me. I'll rebase my dmaslave
patches on top of them; that will probably allow me to get rid of the
dma_slave_descriptor struct.

Haavard
