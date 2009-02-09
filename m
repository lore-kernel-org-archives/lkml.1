Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZBIWXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZBIWXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZBIWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:22:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:37675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbZBIWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:22:51 -0500
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Remis Lima Baima <remis.developer@googlemail.com>
In-Reply-To: <20090209094014.GE7930@elte.hu>
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
	 <20090209094014.GE7930@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 09:21:59 +1100
Message-Id: <1234218119.31963.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 10:40 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Paul,
> > 
> > I found the bug that was causing large modules to fail in setting
> > up dynamic ftrace. It wound up being a simple math error. To calculate
> > the offset in the TOC, I had used an OR, but the bottom half was
> > a signed extended short, and it should have been an addition.
> > The fix is in my tree below, as well as posted here.
> 
> Looks like a .29 candidate?

Yup, I was planning to send it to Linus along with a handful of other
powerpc fixes today, unless you prefer taking it yourself.

Cheers,
Ben.


