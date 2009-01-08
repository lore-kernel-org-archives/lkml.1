Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbZAHTHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbZAHTHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZAHTHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:07:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49372
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755614AbZAHTHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:07:02 -0500
Date: Thu, 08 Jan 2009 11:07:03 -0800 (PST)
Message-Id: <20090108.110703.224751826.davem@davemloft.net>
To: inaky@linux.intel.com
Cc: netdev@vger.kernel.org, wimax@linuxwimax.org, greg@kroah.com,
       randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wimax@intel.com
Subject: Re: [PATCH 1/4] wimax: fix '#ifndef CONFIG_BUG' layout to avoid
 warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <7e92a3e498e02567876f901eba29c59c294a417b.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
	<7e92a3e498e02567876f901eba29c59c294a417b.1231355768.git.inaky@linux.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Wed,  7 Jan 2009 11:22:19 -0800

> Reported by Randy Dunlap:
> 
> > Also, this warning needs to be fixed:
> >
> > linux-next-20090106/net/wimax/id-table.c:133: warning: ISO C90
> > forbids mixed declarations and code
> 
> Move the return on #defined(CONFIG_BUG) below the variable
> declarations so it doesn't violate ISO C90.
> 
> On wimax_id_table_release() we want to do a debug check if CONFIG_BUG
> is enabled. However, we also want the debug code to be always compiled
> to ensure there is no bitrot. It will be optimized out by the compiler
> when CONFIG_BUG is disabled.
> 
> Added a note to the function header stating this.
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Applied.
