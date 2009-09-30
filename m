Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZI3V2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZI3V2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZI3V2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:28:54 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:55981 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbZI3V2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:28:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Tim Gardner <timg@tpi.com>
Subject: Re: [PATCH] e1000e: Fix PCIE error message
Date: Wed, 30 Sep 2009 23:28:54 +0200
User-Agent: KMail/1.9.9
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       e1000-devel@lists.sourceforge.net, jeffrey.t.kirsher@intel.com,
       john.ronciak@intel.com, linux-kernel@vger.kernel.org,
       peter.p.waskiewicz.jr@intel.com
References: <20090930203322.E7963F88DD@sepang.rtg.net>
In-reply-To: <20090930203322.E7963F88DD@sepang.rtg.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909302328.56892.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2009 21:28:57.0246 (UTC) FILETIME=[049A7BE0:01CA4215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner wrote:
> Subject: [PATCH] e1000e: Fix PCIE error message
> 
> BugLink: http://bugs.launchpad.net/bugs/436370
> 
> The error returned by pci_enable_pcie_error_reporting() is ignored, so
> print a notice instead of an error. Users tends to freak out
> when they see messages like this.

There's already a patch in the pipeline that removes the error message 
completely. See http://lkml.org/lkml/2009/8/21/39 for the final version.

I'm not sure why it isn't included in 2.6.31 yet as it was acked by Jeff.

Cheers.
FJP
