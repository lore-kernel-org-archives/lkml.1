Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYAOSbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYAOSbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYAOSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:31:17 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:12599 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYAOSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rqwrcwddnhHQhjhSUnq1c2IGRh4IMVgu/zgbO5NVocGiaIood4RSJOVFhqSbKCJUBNInU52quIEHp0WPSc83VGjRMt0UHC9vMW5tUFWB/oZdJeKBlK4M1IaBIL9paiu2ttos6rAYaRuj53JFqlspKqtaW1LBvLvjiNgVn4x6/og=
Date: Tue, 15 Jan 2008 21:30:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: apw@shadowen.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: add filename in the summary
Message-ID: <20080115183056.GB6723@cvg>
References: <20080114232339.2c018647@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114232339.2c018647@paolo-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paolo Ciarrocchi - Mon, Jan 14, 2008 at 11:23:39PM +0100]
| Add a filename option (default to 0)
| in order to get the following summary output:
| ./scripts/checkpatch.pl --filename --file ./arch/sparc/kernel/apc.c 
| ...
| ...
| ...
| ./arch/sparc/kernel/apc.c --> total: 18 errors, 3 warnings, 186 lines checked
| ---
| 
| Andy, 
| I wonder why checkpatch doesn't show all the command line options. 
| At the moment, it only prints:
| options: -q           => quiet
| 	--no-tree    => run without a kernel tree
|         --terse      => one line per report
|         --emacs      => emacs compile window format
|         --file       => check a source file
|         --strict     => enable more subjective tests
|         --root       => path to the kernel tree root
| 
| but I see a lot more options:
| 	q|quiet
| 	tree
| 	signoff
| 	patch
| 	test-type
| 	emacs
| 	terse
| 	file
| 	subjective
| 	strict
| 	root=s
| 	summary
| 	mailback
| 
| 
|

Hi Paolo,

the options you're complaining about (in most) are enabled by default so
there is no reason to 'turn them on' explicitly /methink/.

		- Cyrill -
