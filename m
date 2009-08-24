Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZHXTnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZHXTnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZHXTnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:43:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZHXTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:43:01 -0400
Date: Mon, 24 Aug 2009 15:42:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
In-Reply-To: <4A8FA2BD.4030707@gmail.com>
Message-ID: <alpine.DEB.2.00.0908241534250.6699@gandalf.stny.rr.com>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com>
 <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 22 Aug 2009, Justin P. Mattock wrote:
> I must admit, I've been afraid of doing
> a git bisect for some time now. but after learning
> to do a bisect, I cant see a better solution to finding a
> bug(biggest issue I see is having a huge .config).

 http://rostedt.homelinux.com/code/streamline_config.pl

It will remove any module from your config that is not loaded. Makes 
compiling kernels much faster.

(also featured in LWN this week: http://lwn.net/Articles/347713/)

-- Steve

