Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbYEAViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbYEAViW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbYEAViN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:38:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbYEAViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:38:12 -0400
Date: Thu, 1 May 2008 17:38:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
In-Reply-To: <1209677160.12461.267.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805011737390.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com> 
 <20080501141919.78b7dc4f.akpm@linux-foundation.org>
 <1209677160.12461.267.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Daniel Walker wrote:
>
> The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> cryptic when there is a failure .. Most people will be baffled why the
> build stopped. If a check went into mainline it should at least give you
> some sort of idea what's happening ..

I can probably change it to be a bit more helpful. I'll work on that too.

-- Steve

