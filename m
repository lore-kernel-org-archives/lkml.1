Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYARIGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYARIGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYARIGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:06:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60215 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYARIGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:06:21 -0500
Date: Fri, 18 Jan 2008 09:06:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Build Failure at scripts/mkubooting/crc32.c
Message-ID: <20080118080627.GB15956@uranus.ravnborg.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479043CA.90002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479043CA.90002@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 11:44:34AM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails with following error message
> 
> scripts/mkubootimg/crc32.c:15:18: error: zlib.h: No such file or directory
> scripts/mkubootimg/crc32.c:77: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc_table'
> scripts/mkubootimg/crc32.c:153: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc32'
> make[2]: *** [scripts/mkubootimg/crc32.o] Error 1
> make[1]: *** [scripts/mkubootimg] Error 2
> make: *** [scripts] Error 2
> 
> The patch causing this build failure may be git-kbuild.patch.

The mkubootimg patches in kbuild.git has been reverted - but that was
after akpm merged kbuild.git.
So it is fixed in next -mm.

The workaround for now is to just remove the line
containing "mkubootimg" in scripts/Makefile.

(Assuming you do not need the uImage target).

	Sam
