Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbYLGJVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbYLGJVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 04:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYLGJV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 04:21:28 -0500
Received: from ozlabs.org ([203.10.76.45]:50782 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYLGJV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 04:21:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Sun, 7 Dec 2008 19:51:18 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812051855.07203.rusty@rustcorp.com.au> <2204.1228478296@redhat.com> <200812052325.22974.rusty@rustcorp.com.au>
In-Reply-To: <200812052325.22974.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071951.18907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008 23:25:22 Rusty Russell wrote:
> On Friday 05 December 2008 22:28:16 David Howells wrote:
> > With that, the core_param stuff does work for mem=...
...
> > It should, perhaps,
> > appear in /proc/cmdline, but for some reason it does not.
> 
> Hmm, that's more concering.  I'll dig into this in the morning.

OK, I can't reproduce it.  I was thinking some weird corner case
with not restoring the string in parse_args, but putting in a dummy
"mem" core_param() on x86 works as first, middle and last arg on cmdline,
and command line shows up correctly in /proc/cmdline.

Any chance I can ask you to verify that?  Is the commandline printk'd
on boot also wrong?

Thanks,
Rusty.
