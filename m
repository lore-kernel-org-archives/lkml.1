Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXAZKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXAZKo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXAZKo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:44:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXAZKoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:44:24 -0500
Date: Fri, 26 Jan 2007 02:44:11 -0800
From: Andrew Morton <akpm@osdl.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: support preset lpj value as config option
Message-Id: <20070126024411.4d4b6c2e.akpm@osdl.org>
In-Reply-To: <45B8F5FB.6090704@am.sony.com>
References: <45B7F5E2.4070800@am.sony.com>
	<20070125021847.GA7609@linux-sh.org>
	<45B8F5FB.6090704@am.sony.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 10:24:59 -0800
Tim Bird <tim.bird@am.sony.com> wrote:

> Paul Mundt wrote:
> > On Wed, Jan 24, 2007 at 04:12:18PM -0800, Tim Bird wrote:
> >> This patch provides a config option for preset lpj, which means
> >> the value can be easily preserved, and conveyed between developers
> >> in a config file.
> >>
> > This seems excessive, it's already possible to set the preset lpj on the
> > kernel command line, and virtually every one of the embedded
> > architectures supports setting the kernel command line as a config
> > option. Is there any reason why you can't simply set it there as a
> > default instead? It's all going to be .config resident in the end
> > anyways.
> 
> i386 is missing CONFIG_CMDLINE support, and this architecture
> is used in embedded.

So if we add CONFIG_CMDLINE we fix this problem and we bring i386 into line
with other platforms.  It's all good.

>  I think many other x86 derivatives are
> also missing .config-based command line support.  CELF has
> worked to get patches submitted to fix this, but so far these
> haven't been accepted.

You have?

<looks at inbox>

To whom?
