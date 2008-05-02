Return-Path: <linux-kernel-owner+w=401wt.eu-S935905AbYEBWcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935905AbYEBWcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbYEBWcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:32:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758278AbYEBWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:32:10 -0400
Date: Fri, 02 May 2008 15:32:10 -0700 (PDT)
Message-Id: <20080502.153210.122414532.davem@davemloft.net>
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HELP: Is writeq an atomic operation??
From: David Miller <davem@davemloft.net>
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Moore, Eric" <Eric.Moore@lsi.com>
Date: Fri, 2 May 2008 16:19:49 -0600

> Is a 64bit write to MMIO registers an atomic operation when using the
> writeq API?  

The answer to this question this is platform dependent.

On most 64-bit platforms, it is.  On some 32-bit ones, it is not.

This is not a SCSI layer question, so belongs minimally on
linux-kernel which I've CC:'d.
