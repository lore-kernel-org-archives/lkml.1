Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZJFHpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZJFHpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZJFHpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:45:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:48493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755373AbZJFHpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:45:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sc+RarcWsXyij2GrL+KFeq0iT8FBk3eFLyTsT+e
	8yPkAES8uVQBcb
Subject: Re: complete IO hang since a few kernel revision
From: Mike Galbraith <efault@gmx.de>
To: Norbert Preining <preining@logic.at>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091006071609.GB21772@gandalf.dynalias.org>
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
	 <4AC9607D.6050900@datenparkplatz.de>
	 <20091005083308.GB5612@gandalf.dynalias.org>
	 <1254813111.6293.22.camel@marge.simson.net>
	 <20091006071609.GB21772@gandalf.dynalias.org>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 09:44:20 +0200
Message-Id: <1254815060.8758.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 16:16 +0900, Norbert Preining wrote:
> On Tue, 06 Oct 2009, Mike Galbraith wrote:
> > I've tried unsuccessfully to reproduce this behavior.
> > 
> > Since it doesn't appear to be something readily reproducible, more
> > information and/or some digging on your part may be needed.
> 
> Hm, how could I do that? I am fine with compiling some strange 
> kernel options, or running some debugging task, but I don't have
> and netconsole or serial console available.

Locating when it started for you would be valuable, even if it's not
pin-pointed such as a git bisection could do.  A bisection is the best
bet to nail it down, but can be quite time consuming.

One thing you can try is to drop to a non-gui shell, and see it the
symptom is reproducible without the GUI.  If it is, poke SysRq-W while
things are thoroughly jammed up, and post the output+config here.

	-Mike

