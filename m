Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZGXAaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZGXAaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZGXAaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:30:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZGXAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:30:03 -0400
Date: Thu, 23 Jul 2009 20:30:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: remove max_tracer_type_len
In-Reply-To: <4A66D50A.6050307@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907232028351.8469@gandalf.stny.rr.com>
References: <4A66D50A.6050307@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Li Zefan wrote:

> Limit the length of a tracer's name within 100 chars, and then we
> don't have to play with max_tracer_type_len.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Heh, sometimes I like to keep things dynamic a bit too much. Allowing any 
size tracer name is probably going too far in that respect.

Thanks, I'll go ahead and queue this up for 32.

-- Steve

