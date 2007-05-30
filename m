Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXE3N5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXE3N5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXE3N5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:57:09 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:60822 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbXE3N5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:57:08 -0400
Date: Wed, 30 May 2007 06:56:38 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel modifications
Message-ID: <20070530135638.GA21569@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com> <20070530004658.732451ad.sfr@canb.auug.org.au> <20070530113403.GA14480@lnx-holt.americas.sgi.com> <20070530234206.ae2bec8d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530234206.ae2bec8d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Wed, May 30, 2007 at 11:42:06PM +1000, Stephen Rothwell wrote:
> On Wed, 30 May 2007 06:34:03 -0500 Robin Holt <holt@sgi.com> wrote:
> >
> > That breaks git-bisect.  Just introducing new text, but not actually using
> > it makes it appear to somebody using git-bisect to identify the source of
> > a problem as though all the changes came in at the same time.  Bad idea.
> 
> But the patch set as it is includes references to files that do not exist
> and so breaks the build.
> 

The patches are split artificially to make it easier to read on LKML.

There is no intention on my part to make them such that individually they
can build a kernel. You need at least the base+common+ your arch to
compile. The common code is divided by functionality. All functionalities
are required.

-- 
-Stephane
