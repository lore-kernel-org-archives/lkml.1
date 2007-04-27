Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXD0A63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXD0A63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXD0A63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:58:29 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbXD0A62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:58:28 -0400
Message-ID: <46314AAD.9010300@zytor.com>
Date: Thu, 26 Apr 2007 17:58:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com> <46314A08.9000209@redhat.com>
In-Reply-To: <46314A08.9000209@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> H. Peter Anvin wrote:
>> I'm a bit leery of abusing the timespec value like this, though.  A
>> flags field seem like it would be cleaner.
> 
> It's ugly.  Then you have the parameter, which might have nice valid
> values, and they get ignored.  I thought about it when this was
> discussed in the working group and thought it's a toss up.

It's pretty ugly either way :-/

>> Something else... if we're dickering with these interfaces, shouldn't we
>> allow setting atime as well?
> 
> Why?  To allow somebody to hide her/his tracks?

Primarily to let a backup program restore the full state of the filesystem.

	-hpa
