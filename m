Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZERAm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZERAm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 20:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZERAmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 20:42:16 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:57709 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZERAmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 20:42:16 -0400
Subject: Re: [tracing] ring_buffer question
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1242594505.6327.3.camel@localhost.localdomain>
References: <1242594505.6327.3.camel@localhost.localdomain>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 17 May 2009 20:39:42 -0400
Message-Id: <1242607182.6327.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 17:08 -0400, Jon Masters wrote:

> Is there any reason you can think of why we don't just generalize
> kernel/trace/ring_buffer into kernel/ring_buffer, remove the static
> per_cpu buffer allocation and have this available for non-tracing?

Ignore the latter point - I realize that I can use ring_buffer_alloc,
etc. quite happily. I am doing that now in my smi_detector rewrite. But
I still think the RB is a little too tracing specific - so, perhaps we
can move it out of kernel/trace. I'll write up something once I've
figured out this stuff to go along with the excellent trace docs since
the generic ring buffer implementation is really quite sexy stuff.

[thinking out loud] Does the global disable stuff also disable other
non-tracing ring buffers?

Jon.


