Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886Ab0ASVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0ASVTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784Ab0ASVTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:19:30 -0500
Received: from kroah.org ([198.145.64.141]:53483 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab0ASVSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:18 -0500
Date: Tue, 19 Jan 2010 13:04:17 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-ID: <20100119210417.GC10928@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119172741.2dd81553.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 05:27:41PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> drivers/base/cpu.c:264: warning: initialization from incompatible pointer type
> drivers/base/cpu.c:265: warning: initialization from incompatible pointer type
> 
> Introduced by commit 380567d3dc35a62f5cc0ec640a45dfc238238417 ("sysdev:
> Convert node driver")?

No, I don't think that patch causes the warning, I can't duplicate it
here.

I don't know what patch causes that problem, as I can't duplicate it in
my tree at all.  Maybe some 'const' patch snuck in from some other tree?

strange,

greg k-h
