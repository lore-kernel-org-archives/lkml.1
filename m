Return-Path: <linux-kernel-owner+w=401wt.eu-S1761162AbYBOIMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162AbYBOIMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYBOIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:12:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYBOIMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:12:44 -0500
Date: Fri, 15 Feb 2008 09:48:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080215084827.GB25949@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203050886.30010.19.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:48:06PM +0800, Huang, Ying wrote:
> 
> This patch has been tested on Intel x86 platform with EFI 32/64.

Can EFI_PAGE_SIZE ever be < 4k? If yes you would need to round up
first to linux page size before shifting.

-Andi

