Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXLZSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXLZSGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXLZSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:06:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:63514 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXLZSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:06:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,209,1196668800"; 
   d="scan'208";a="245832952"
Message-ID: <477297DD.8090704@intel.com>
Date: Wed, 26 Dec 2007 10:05:17 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: pradeep pradeep <asnvpradeep@yahoo.com>
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: VGA Drivers
References: <691805.30097.qm@web94706.mail.in2.yahoo.com>
In-Reply-To: <691805.30097.qm@web94706.mail.in2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Dec 2007 18:06:02.0577 (UTC) FILETIME=[F9E86C10:01C847E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pradeep pradeep wrote:
> Hi,
>     I want to support a new PCI based VGA card in
> linux. I want to know what is the VGA driver stack in
> the Linux. Can any one help me where to start.

Assuming you're not talking about a VGA grabber card here...

Graphics/ X drivers are mostly in userspace except some DRI/DRM infrastructure and
AGP code. You should start looking at the XOrg project.

The kernel has some framebuffer support, but I'm not sure that is what you are
looking for.
