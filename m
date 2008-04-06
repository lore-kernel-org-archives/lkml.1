Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYDFUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYDFUj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYDFUju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:39:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbYDFUjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:39:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Sun, 6 Apr 2008 22:39:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200804041222.35025.elendil@planet.nl>
In-Reply-To: <200804041222.35025.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062239.44861.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of April 2008, Frans Pop wrote:
> While compiling glibc I am getting frequent short skips in music play 
> anddddddddddddddddd I have now three times seen key repeats (as in this 
> sentence). When there is a skip in the music, there is also a delay in 
> characters being typed appearing on the screen.
> 
> I have not seen these symptoms with earlier rc releases (at least, not since 
> rc1), but I have not really done many heavy compilations recently, so I'd 
> have to spend some time to verify where this started.
> 
> The problem seems somewhat different from what we had with rc1 as the mouse 
> is smooth.
> 
> System is dual core Pentium D (x86_64). During the compilation one processor 
> core is basically idle. The music files are being read from an NFS share.

Can you test with CONFIG_GROUP_SCHED unset, please?

Rafael
