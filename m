Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXEaUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXEaUwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXEaUwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:52:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39212 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXEaUwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:52:25 -0400
Date: Thu, 31 May 2007 22:53:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section mismatches
Message-ID: <20070531205326.GH27305@uranus.ravnborg.org>
References: <20070530180217.bebfa4b0.akpm@linux-foundation.org> <20070531045033.GB20795@uranus.ravnborg.org> <20070530215631.bb847429.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530215631.bb847429.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:56:31PM -0700, Andrew Morton wrote:
> On Thu, 31 May 2007 06:50:33 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Is it correct assumed that start_kernel() is never called in the HOTPLUG case since we
> > are dealign with CPU #2 and more?
> 
> start_kernel is called once, on the boot CPU, before the other CPUs are
> brought up.
As expectyed - thanks.
I'm buried in section mismatch warnings at the moment but will come back to this
one a bit later. This needs a bit more careful thinking.

	Sam
