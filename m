Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbZLPXKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbZLPXKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761569AbZLPXKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:10:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761507AbZLPXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:10:04 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1260907788.6521.10.camel@keith-laptop>
References: <1260907788.6521.10.camel@keith-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 00:09:24 +0100
Message-ID: <1261004964.21028.521.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 12:09 -0800, Keith Mannthey wrote:
> This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
> feature allows non-fatal System Management Interrupts (SMIs) to be
> disabled on supported IBM platforms. 
> 
> 
> The Device is presented as a special "_rtl_" table to the OS in the
> Extended BIOS Data Area.  There is a simple protocol for entering and
> exiting the mode at runtime.  This driver creates a simple sysfs
> interface to allow a simple entry and exit from RTL mode in the
> UFI/BIOS. 

Why not simply always run with these non-fatal SMIs disabled and provide
their function through the OS proper?

That way you don't need no silly switches and gain consistent platform
behaviour.

