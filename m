Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZHQMFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZHQMFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZHQMFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:05:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZHQMFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:05:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: suspend  tree build failure
Date: Mon, 17 Aug 2009 14:06:02 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090817184048.db6d94f9.sfr@canb.auug.org.au>
In-Reply-To: <20090817184048.db6d94f9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908171406.02278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 August 2009, Stephen Rothwell wrote:
> [Sorry if some get this twice, I fixed up the subject.]
> 
> Hi Rafael,

Hi,

> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/base/power/runtime.c:948: error: __ksymtab_pm_runtime_disable causes a section type conflict
> 
> Caused by commit d9d4cc5169ca18df9ff5afd31c6e6b715ecb454a ("PM: Introduce
> core framework for run-time PM of I/O devices (rev. 17)") from the
> suspend tree.  This commit EXPORTs pm_runtime_disable which is an inline
> function that calls __pm_runtime_disable (which is probably what was
> meant to be EXPORTed).
> 
> I wish we could get these type of errors to fail on x86 as well ...
> 
> I have applied the following patch for today.

Thanks for the patch, I'll fix up the tree later today.

Best,
Rafael
