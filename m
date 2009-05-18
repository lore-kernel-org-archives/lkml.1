Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZERQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZERQxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZERQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:53:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZERQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:53:46 -0400
Message-ID: <4A119264.9010807@redhat.com>
Date: Mon, 18 May 2009 11:52:52 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [tracing] ring_buffer question
References: <1242594505.6327.3.camel@localhost.localdomain> <1242607182.6327.8.camel@localhost.localdomain> <4A1185B9.8050301@redhat.com> <alpine.DEB.2.00.0905181222410.21785@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905181222410.21785@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 18 May 2009, David Smith wrote:
> 
>> Jon Masters wrote:
>>> [thinking out loud] Does the global disable stuff also disable other
>>> non-tracing ring buffers?
>> I believe it does.  If I'm correct, I think it would be a good idea to
>> make that an ftrace-disable feature, not a general ring buffer disable
>> feature.
> 
> We can do that when we get more users of the ring buffer and we find it 
> makes sense.

It appears that oprofile is already using the ring buffer.  With Jon's
stuff as a 2nd non-ftrace-user, doesn't it make sense now?

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
