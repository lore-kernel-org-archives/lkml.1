Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbZJFUvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbZJFUvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbZJFUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:51:12 -0400
Received: from khc.piap.pl ([195.187.100.11]:55523 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218AbZJFUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:51:12 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	<4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	<1254406711.18167.88.camel@desktop>
Date: Tue, 06 Oct 2009 22:50:32 +0200
In-Reply-To: <1254406711.18167.88.camel@desktop> (Daniel Walker's message of
	"Thu, 01 Oct 2009 07:18:30 -0700")
Message-ID: <m33a5ww8kn.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

> In terms of the list getting long or not, your basically in control of
> it since you maintain checkpatch .. If you leave it without some sort of
> blacklist, then you end up with whole sections of code where the
> developers don't use checkpatch at all (or very little)..

Why? I routinely ignore specific warnings from checkpatch while paying
attention to other ones. That's precisely what one should expect if the
code in question technically violates the common style (or whatever is
it). I don't think we need exceptions in the checkpatch as they would
make it less useful and less reliable.
-- 
Krzysztof Halasa
