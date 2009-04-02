Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbZDBRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbZDBRzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZDBRzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:55:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:46051 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbZDBRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:55:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,315,1235980800"; 
   d="scan'208";a="444450379"
Date: Thu, 2 Apr 2009 10:55:40 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Mark Lord <liml@rtr.ca>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 5/5] libata: Add support for TRIM
Message-ID: <20090402175539.GR2661@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <1238683047-13588-5-git-send-email-willy@linux.intel.com> <49D4F3C1.3070200@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4F3C1.3070200@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:20:01PM -0400, Mark Lord wrote:
> Now we just need an implementation of ata_discard_fn()
> that issues the CFA ERASE SECTORS command instead of TRIM
> when speaking to a CFA device.

Yes, should be quite straightforward.  The only minor wrinkle I can see
is that CFA ERASE SECTORS only allows you to erase up to 256 sectors at a
time.  I think Dave's infrastructure for Discard lets us handle that ...

> Ah, life is good!

Isn't it though?
