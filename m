Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbZJAO0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbZJAO0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932474AbZJAO0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:26:17 -0400
Received: from fifo99.com ([67.223.236.141]:38381 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbZJAO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:26:16 -0400
Subject: Re: [PATCH 4/5] checkpatch: fix __attribute__ matching
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090930174624.GF2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
	 <20090930174624.GF2957@shadowen.org>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 07:26:12 -0700
Message-Id: <1254407172.18167.96.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:46 +0100, Andy Whitcroft wrote:

> The problem with the __attribute__ match is that it is impossible to
> sensibly write as a regular-expression as it has nested round brackets
> within it.  I do wonder why we care what is before the equals.  I
> suspect that any assignment ='s followed by a newline, followed by a {
> is wrong.  There are few places that a { is right on the next line.

Yeah, I was thinking about that also .. I though there might be some
"= {" situation I wasn't thinking of tho.

> I'll try that one out and see if it fires any false positives.  Its
> passing my tests here.
> 
> Could you see if the version at the url below works better for you:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

I'm wondering about your release cycle .. You seem to be selectively
sending patches to Andrew ? Have you considered putting all your changes
into Linux-Next for instance then just keep up with the merge-window
cycle ? Either that or send everything to Andrew.. Either way, you would
have all the changes getting tested, instead of something like above
where is "testing" or a version number at an obscure url location..

Daniel

