Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYLaAhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYLaAhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYLaAhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:37:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYLaAha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:37:30 -0500
Message-ID: <495ABDF8.2070703@kernel.org>
Date: Tue, 30 Dec 2008 16:34:00 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org>
In-Reply-To: <495AA87D.9060704@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Applied to tip:tracing/kmemtrace2.
> 

Hm, there still seems to be a build failure, in particular
trace_output.h is missing.  It looks to me at the moment as if just
removing the #include works; assuming that compiles I will check that in
to tip:tracing/kmemtrace2 as well.

	-hpa
