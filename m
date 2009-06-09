Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZFIQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZFIQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZFIQM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:12:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33140 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZFIQM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:12:56 -0400
Date: Tue, 9 Jun 2009 18:15:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kbuild tree build failure
Message-ID: <20090609161512.GB6675@uranus.ravnborg.org>
References: <20090609114820.69d23ab3.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609114820.69d23ab3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 11:48:20AM +1000, Stephen Rothwell wrote:
> Hi Sam,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> powerpc-linux-ld:arch/powerpc/kernel/vmlinux.lds:190: syntax error
> 
> Caused by commit 59d59d97e34c6593bec43666679b28da5d583958 ("Improve
> vmlinux.lds.h support for arch specific linker scripts") which was
> clearly not build tested - don't do that! There is a missing \ at the end
> of a line in the definition of the HEAD_SECTION macro.
> 
> I have used the version of the kbuild tree from next-20090605.

My bad - obviously.
I will fix when the kids are sleeping (as in a few hours from now).

	Sam
