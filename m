Return-Path: <linux-kernel-owner+w=401wt.eu-S965372AbXFFWkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372AbXFFWkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXFFWjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:39:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40603 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbXFFWjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:39:20 -0400
Date: Wed, 6 Jun 2007 15:37:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-Id: <20070606153737.2c9da784.randy.dunlap@oracle.com>
In-Reply-To: <200706061528.44070.jesse.barnes@intel.com>
References: <200706061229.24486.jesse.barnes@intel.com>
	<200706061524.52628.jesse.barnes@intel.com>
	<Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
	<200706061528.44070.jesse.barnes@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 15:28:43 -0700 Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
> > Nope, I booted with only netconsole= options.  I have a lot of HW in
> > the box and I guess the buffer is too small.  Not sure where to
> > change it in the kernel.  Looking..
> 
> It's called "kernel log buffer size" and it's in "General setup".

or you can just boot with "log_buf_len=256k" on the kernel boot line (e.g.)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
