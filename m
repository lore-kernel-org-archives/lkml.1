Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZEEAST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZEEAST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZEEAR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:17:57 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:3194 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZEEARz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:17:55 -0400
X-IronPort-AV: E=Sophos;i="4.40,294,1238976000"; 
   d="scan'208";a="180739074"
Date: Mon, 4 May 2009 17:17:56 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 3/5] initdev:kernel: Await console discovery, v5
Message-ID: <20090505001756.GB29124@cuplxvomd02.corp.sa.net>
References: <20090502022756.GA15838@cuplxvomd02.corp.sa.net> <20090502113825.11bc7876@linux-lm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502113825.11bc7876@linux-lm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 11:38:25PM -0400, Ming Lei wrote:
> On Fri, 1 May 2009 19:27:56 -0700
> David VomLehn <dvomlehn@cisco.com> wrote:
...
> > diff --git a/drivers/accessibility/braille/braille_console.c
> > b/drivers/accessibility/braille/braille_console.c index
> > d672cfe..4420ac3 100644 ---
> > +
> > +	initdev_register(BOOTDEV_CONSOLE);
> 
> Should it be initdev_registered(BOOTDEV_CONSOLE)?

Yes.

> Lei Ming

Thanks!

David VomLehn
