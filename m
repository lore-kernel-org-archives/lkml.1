Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbXGZKJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbXGZKJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXGZKJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:09:15 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:51111 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXGZKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:09:15 -0400
Date: Thu, 26 Jul 2007 13:09:02 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: Calgary - fix section mismatch warnings in tce
Message-ID: <20070726100902.GP4104@rhun.haifa.ibm.com>
References: <20070726062330.GA1322@uranus.ravnborg.org> <20070726090611.GL4104@rhun.haifa.ibm.com> <20070726100238.GA2779@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726100238.GA2779@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 12:02:38PM +0200, Sam Ravnborg wrote:

> Now I recall I saw it too :-(

> This one is beeter although the __init in the prototype declaration
> should have no effect. (Also wonder why the prototypes are extern -
> that should be a no-op too).

The __init in the prototype is for consistency's sake with the
definition. The extern I have no idea... probably legacy from some
other code, but they don't bother me.

Anyway, forgot to mention earlier - thanks for your patch!

Cheers,
Muli
