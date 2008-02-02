Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbYBBTYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbYBBTYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbYBBTYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:24:33 -0500
Received: from main.carme.maven.pl ([193.239.45.138]:16282 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363AbYBBTYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:24:30 -0500
X-Greylist: delayed 1714 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Feb 2008 14:24:30 EST
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] 2.6.22-stable review
Date: Sat, 2 Feb 2008 19:55:53 +0100
User-Agent: PLD Linux KMail/1.9.6 (enterprise 0.20071204.744707)
References: <20080202001927.GA8368@suse.de>
In-Reply-To: <20080202001927.GA8368@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802021955.53923.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 of February 2008, you wrote:
> This is the start of the stable review cycle for the 2.6.22.17 release.
> There are 27 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.

btw. does this program hang for anyone on 2.6.22 (process in D state) ?

#include <stdio.h>
#include <sched.h>
 
int main( void )
{
        cpu_set_t cpu;
        int cpus = 0;
        int ret;
        ret = sched_getaffinity(getpid(), sizeof(cpu), &cpu);
        printf( "cpus = %d, ret = %d\n", cpu, ret );
        sched_setaffinity(getpid(), sizeof(cpu), &cpu);
        printf( "ret = %d\n" );
        return ret;
}


-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
