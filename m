Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbYBGU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbYBGU3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYBGU3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:29:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35120 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYBGU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:29:09 -0500
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick
	start
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47AB25AD.30400@openvz.org>
References: <47AB25AD.30400@openvz.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:28:57 +0100
Message-Id: <1202416137.6274.42.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 18:37 +0300, Pavel Emelyanov wrote:
> The Documentation/cgroups.txt file contains the info on how
> to write some controller for cgroups subsystem, but even with
> this, one need to write quite a lot of code before developing
> the core (or copy-n-paste it from some other place).
> 
> I propose to put this minimal controller into Documentation
> directory to let people copy-n-paste a) from a known place and 
> b) a small piece of code.
> 
> Besides, many people learn better reading an example rather
> than/along with a document.


While on the subject, could someone document struct cgroup_subsys. In
particular, I've wondered why we have: cgroup_subsys::can_attach() and
not use a return value in cgroup_subsys::attach()?



