Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZHJOID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZHJOID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZHJOIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:08:02 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbZHJOIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:08:01 -0400
Subject: Re: linux-next: security-testing tree build failure
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090807145932.77bc2c98.sfr@canb.auug.org.au>
References: <20090807145932.77bc2c98.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 10:07:49 -0400
Message-Id: <1249913269.2081.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 14:59 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> kernel/sysctl.c:1321: error: 'mmap_min_addr_handler' undeclared here (not in a function)
> mm/mmap.c: In function 'do_mmap_pgoff':
> mm/mmap.c:935: error: implicit declaration of function 'round_hint_to_min'
> 
> Caused by commit a2551df7ec568d87793d2eea4ca744e86318f205
> ("Security/SELinux: seperate lsm specific mmap_min_addr") -
> CONFIG_SECURITY is not set in this build.
> 
> I have used the version of the security-testing tree from next-20090806
> for today.

Sorry, I thought I put the definitions outside of the ifdef in
security.h but clearly they aren't.  Looks like James's tree has the fix
as of a couple of hours ago, so you should be fix on your next pull from
him.

-Eric

