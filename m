Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbZD1DA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbZD1DA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbZD1DAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:00:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374AbZD1DAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:00:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/linus
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Better document some regset helper functions
In-Reply-To: David Howells's message of  Tuesday, 28 April 2009 00:30:21 +0100 <20090427233020.676.17406.stgit@warthog.procyon.org.uk>
References: <20090427233020.676.17406.stgit@warthog.procyon.org.uk>
Emacs: impress your (remaining) friends and neighbors.
Message-Id: <20090428025926.599FEFC3C6@magilla.sf.frob.com>
Date: Mon, 27 Apr 2009 19:59:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm all for better comments and your text looks fine to me.

The reason I had not used kerneldoc comments for those helpers is that
these are the private helpers purely for the use of arch code implementing
user_regset accessor functions.  By contrast, the calls in linux/regset.h
that have kerneldoc comments are those that generic code (including future
modules, etc.) uses.  When generating DocBook or man pages, the regset.h
functions are grouped together and those that have kerneldoc today make
sense to have there, but IMHO these inline helpers for arch code do not.


Thanks,
Roland
