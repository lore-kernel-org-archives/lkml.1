Return-Path: <linux-kernel-owner+w=401wt.eu-S936888AbYD1Uk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936888AbYD1Uk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934229AbYD1UkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:40:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39180 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934220AbYD1UkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:40:18 -0400
Date: Mon, 28 Apr 2008 22:40:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] make help: Show defconfig subdirs
Message-ID: <20080428204050.GB18248@uranus.ravnborg.org>
References: <f70d44df351c88b7754e2ca93c6075f9660d3a40.1207512931.git.segher@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f70d44df351c88b7754e2ca93c6075f9660d3a40.1207512931.git.segher@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 10:16:07PM +0200, Segher Boessenkool wrote:
> PowerPC will start moving board defconfigs into subarch-specific
> subdirs soon.  "make help" currently does not look in subdirs to
> find the defconfigs to show.  This is partially a good thing,
> since there are way too many defconfigs for one list.
> 
> This patch makes the main "make help" display something like
> 
>   help-40x         - Show 40x-specific targets
>   help-44x         - Show 44x-specific targets
>   help-boards      - Show all of the above
> 
> and wires up stuff so those new help-* commands actually work.
> 
> Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>

Thanks, applied.
Fixed it up to show x86 defconfig files too.

	Sam
