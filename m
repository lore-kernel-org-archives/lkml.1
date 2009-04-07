Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbZDGWQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbZDGWQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbZDGWP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:15:56 -0400
Received: from mga05.intel.com ([192.55.52.89]:41314 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756126AbZDGWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,339,1235980800"; 
   d="scan'208";a="679635520"
Date: Tue, 7 Apr 2009 15:15:54 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Message-ID: <20090407221554.GA4527@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <20090402165117.GQ2661@linux.intel.com> <200904022137.35671.bzolnier@gmail.com> <200904072339.00224.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904072339.00224.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 11:38:59PM +0200, Bartlomiej Zolnierkiewicz wrote:
> I would like to see this merged for -rc1 so I tried to put it altogether
> and then integrate it over recent IDE and block changes...

You're missing 1/5 and 2/5.  This patch will crash horribly if you use
it with a drive which supports TRIM.
