Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZFSSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZFSSfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZFSSf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:35:26 -0400
Received: from sous-sol.org ([216.99.217.87]:51915 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZFSSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:35:26 -0400
Date: Fri, 19 Jun 2009 11:34:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: James Morris <jmorris@namei.org>, Joseph Cihula <joseph.cihula@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       Chris Wright <chrisw@sous-sol.org>, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090619183414.GG19771@sequoia.sous-sol.org>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619150514.GE1389@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> What are non-evil uses of this code?

The most common use case I've heard requested from real live
customers[1] is...you guessed it...trusted boot.

This is typically in the context of virtualization and data centers or
clouds.  The concerns being addressed are:

* confidence that the hardware is running the VMM that the hardware
  owner configured it w/, since they are on the hook for providing a
  safe service for each VM running on that hardware

* flip side of that is an additional layer protecting against malicious
  VM that is using some VMM hole to try and subvert the host w/ a VMM
  of their own

thanks,
-chris
--

[1] as opposed to hardware vendors pushing a feature
