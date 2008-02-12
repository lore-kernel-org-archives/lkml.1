Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbYBLKCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbYBLKCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbYBLKCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:02:15 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49804 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbYBLKCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:02:14 -0500
Date: Tue, 12 Feb 2008 11:02:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc1, weird build error
Message-ID: <20080212100221.GA31701@uranus.ravnborg.org>
References: <20080212070448.GA20033@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212070448.GA20033@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 08:04:48AM +0100, Ingo Molnar wrote:
> 
> i've got a build log from a weird build error below:
> 
>   LD      init/built-in.o
> distcc[12023] ERROR: compile (null) on localhost failed
> make: *** [vmlinux.o] Error 1
> make: *** Waiting for unfinished jobs....
>   LD      .tmp_vmlinux1
>
Looks like a missing dependency on vmlinux.o so we build
init/built-in.o in parallel with vmlinux.o => boom.
Will look further into this tonight.

	Sam
