Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXDGXal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXDGXal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 19:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965985AbXDGXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 19:30:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32832 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965966AbXDGXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 19:30:40 -0400
Date: Sun, 8 Apr 2007 00:30:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070407233037.GA16508@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407203633.GA21555@thunk.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 04:36:33PM -0400, Theodore Tso wrote:
> this functionality, and it is highly questionable how useful it is,
> anyway.  If you use telldir/seekdir and keep the cookie for a long
> time, even the POSIX-provided guarantees about files that are created
> and deleted between the telldir() and seekdir() points in time makes
> its utility highly dubious.

It's not going to solve anything at all.  We can't stop supporting
functionality that has been there forever. 

