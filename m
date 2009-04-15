Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZDOOYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZDOOYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZDOOX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:23:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58177 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZDOOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:23:55 -0400
Subject: Re: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090415141221.GE12760@elte.hu>
References: <49E2AAB3.9010801@cn.fujitsu.com>
	 <1239633781.21121.25.camel@localhost.localdomain>
	 <49E5A593.6090605@cn.fujitsu.com>
	 <1239803101.21121.69.camel@localhost.localdomain>
	 <20090415141221.GE12760@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 15 Apr 2009 10:23:40 -0400
Message-Id: <1239805420.21121.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-04-15 at 16:12 +0200, Ingo Molnar wrote:
> * Steven Rostedt <srostedt@redhat.com> wrote:

> Yeah - format specifications are always good. They weaken ABI 
> bindings and allow more flexibility both on the tool and the kernel 
> side.
> 
> > We could ask Linus to pull this into 30 because it is a API 
> > change.
> 
> Apps could assume if the format file is not there it's the .30 
> format.

My fear is that they are written before the change, and will not know
about a format file existing. Then those apps will break on 31.

But this is still new, and the only user I know of at the moment is the
University student doing the ftrace GUI. I'll keep him informed.

Thanks,

-- Steve


