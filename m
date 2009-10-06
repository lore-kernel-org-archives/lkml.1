Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZJFRou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZJFRou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZJFRot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:44:49 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:54399 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbZJFRot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:44:49 -0400
X-Loopcount0: from 143.166.82.43
Date: Tue, 6 Oct 2009 12:44:11 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] firmware: only allow EDD on x86
Message-ID: <20091006174411.GB15751@auslistsprd01.us.dell.com>
References: <1254808627-3889-1-git-send-email-vapier@gentoo.org> <1254814818-15658-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254814818-15658-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:40:18AM -0400, Mike Frysinger wrote:
> Rather than have the EDD depend on !ia64 (and assuming that only ia64,
> x86, x86_64 will be including this Kconfig), have EDD depend on the only
> arches which can support this code.  This should allow all other arches
> to cleanly include the firmware Kconfig.
> 
> Also simplify the x86 string used by FIRMWARE_MEMMAP to match EDD.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Matt Domsch <Matt_Domsch@del.com>

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
