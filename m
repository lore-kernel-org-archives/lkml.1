Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbZB0VUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbZB0VUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZB0VTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:19:53 -0500
Received: from fifo99.com ([67.223.236.141]:39956 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZB0VTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:19:52 -0500
Subject: Re: [PATCH] Don't profile branches in arm's boot decompressor
From: Daniel Walker <dwalker@fifo99.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Feb 2009 13:19:47 -0800
Message-Id: <1235769587.8233.1.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 22:09 +0100, Uwe Kleine-König wrote:
> This fixes many compile errors for arch/arm/boot/compressed/misc.c of
> the type:
> 
> 	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables

Why do you think this error showed up just in that one file? It looks
like the branch tracer puts section tags on non-globals all over the
kernel..

Daniel

