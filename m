Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZAET5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZAET5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZAET5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:57:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZAET5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:57:01 -0500
Date: Mon, 5 Jan 2009 14:56:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] sparc: make proces_ver_nack a bit more readable
In-Reply-To: <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901051455510.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Steven Rostedt wrote:

> 
> Impact: clean up
> 
> The code in process_ver_nack is a little obfuscated. This change
> makes it a bit more readable by humans. It removes the complex
> if statement and replaces it with a cleaner flow of control.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Sam,

Can you test to see if this patch makes the issue go away. Obviously, Dave 
would need to be the one to pull it in, or at least ack it.

Thanks,

-- Steve
