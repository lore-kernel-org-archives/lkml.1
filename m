Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXHOEDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXHOEDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 00:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXHOEDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 00:03:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37667 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbXHOEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 00:03:43 -0400
Date: Tue, 14 Aug 2007 21:08:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc3 won't boot on alpha
Message-Id: <20070814210832.f2694735.randy.dunlap@oracle.com>
In-Reply-To: <20070815022312.A4073DBA2@gherkin.frus.com>
References: <20070815022312.A4073DBA2@gherkin.frus.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007 21:23:12 -0500 (CDT) Bob Tracy wrote:

> Unfortunately, I can't say where the bug was introduced, as this is
> the first kernel I've tried on my Alpha since 2.6.22-rc7.  Best guess
> is somewhere between .23-rc1 and .23-rc2, based on changes to files in
> arch/alpha/boot in that patch set.  The problem happens early: aboot
> starts to load vmlinux.gz, and I get an "unzip: invalid exec header"
> error.  There's an earlier error from aboot I can't quote exactly, but
> the template from aboot (bootlx) is:
> 
> aboot: Can't load kernel.
>   Memory at %lx - %lx (chunk %i) is %s
> 
> The first %lx is all zeros.  The last %lx is all "F"s.  The chunk
> number is 1, and I *think* the %s is "busy".

try http://lkml.org/lkml/2007/8/14/259

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
