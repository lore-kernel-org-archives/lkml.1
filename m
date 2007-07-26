Return-Path: <linux-kernel-owner+w=401wt.eu-S934943AbXGZTRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbXGZTRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762664AbXGZTRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:17:46 -0400
Received: from main.gmane.org ([80.91.229.2]:54011 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761238AbXGZTRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:17:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: sk98lin for 2.6.23-rc1
Date: Thu, 26 Jul 2007 20:17:31 +0100
Organization: Linux Foundation
Message-ID: <20070726201731.03d3f590@oldman>
References: <46A8BAD4.8020004@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87.192.216.40
In-Reply-To: <46A8BAD4.8020004@akamai.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 11:16:36 -0400
Kyle Rose <krose@akamai.com> wrote:

> From http://www.krose.org/~krose/computing.html:
> 
> Since the sky2 driver continues to suck ass (which is a technical
> description for "it hangs all the time under load, at least on my
> hardware" :-) ), I've fixed the sk98lin driver to compile for
> linux-2.6.23-rc1. Those who continue to have problems with sky2 can
> still use 2.6.23-rc1, simply by doing the following:
>

Just don't build it with lock debugging enabled or you will see all the
deadlocks lying below the surface.  Worse yet, read the macro hell
of sky2le.h

