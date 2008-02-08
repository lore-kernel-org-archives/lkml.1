Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbYBHFeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbYBHFeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYBHFeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:34:14 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:35244 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYBHFeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:34:13 -0500
X-IronPort-AV: E=Sophos;i="4.25,319,1199685600"; 
   d="scan'208";a="529597598"
Date: Thu, 7 Feb 2008 23:33:59 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMI: add-type-41
Message-ID: <20080208053359.GE7226@auslistsprd01.us.dell.com>
References: <20080125201911.GB3234@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125201911.GB3234@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 09:19:11PM +0100, Wim Van Sebroeck wrote:
> Hi All,
> 
> Would appreciate feedback on this patch.
> 
> Thanks in advance,
> Wim.
> 
> commit 4956e4e5e77b5a8f87bcfe6127ef17a406edf94b
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Mon Dec 31 17:21:33 2007 +0000
> 
>     [PATCH] SMBIOS/DMI - add type 41 = Onboard Devices Extended Information

Is there something in the kernel that will consume this data, or is it
being exported in /sys/class/dmi/id somehow?  There will be one table
entry per device (Dell PowerEdge x9xx servers with recent BIOS do so).

FWIW, my biosdevname app consumes this data, using dmidecode from
userspace.


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
