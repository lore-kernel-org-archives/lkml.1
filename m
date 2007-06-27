Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbXF0QIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbXF0QIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbXF0QIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:08:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:12292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbXF0QIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,467,1175497200"; 
   d="scan'208";a="243991651"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 27 Jun 2007 09:07:31 -0700
User-Agent: KMail/1.9.7
Cc: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706270804.53263.jesse.barnes@intel.com> <468289A1.3080709@macroscoop.nl>
In-Reply-To: <468289A1.3080709@macroscoop.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270907.32279.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 27, 2007 9:00:33 Pim Zandbergen wrote:
> Jesse Barnes wrote:
> > Yeah, you're right I should use an unsigned format string.  Pim, if
> > you change it to %lu does the printk in your dmesg look better?
>
> Er, no.
>
> **** MTRRs don't cover all of memory, trimmed 18446744073709486080
> pages

Hm, that's what I was afraid of.  So something else is wrong. :)

Jesse
