Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYG1VmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYG1VmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYG1VmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:42:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYG1VmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:42:14 -0400
Date: Mon, 28 Jul 2008 23:41:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Sterba <dsterba@suse.cz>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [build error] drivers/char/pcmcia/ipwireless/hardware.c:571:
	error: invalid use of undefined type 'struct ipw_network'
Message-ID: <20080728214153.GA30511@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu> <20080728213532.GA24744@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728213532.GA24744@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This has a trivial conflict with the latest tree you just pushed out. 

btw., if you intend that for -rc1, that tree has a common looking build 
failure:

drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of 
undefined type 'struct ipw_network'

http://redhat.com/~mingo/misc/config-Mon_Jul_28_23_36_20_CEST_2008.bad

probably due to a string of commits to that file from today.

	Ingo
