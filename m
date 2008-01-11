Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbYAKJGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbYAKJGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYAKJG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:06:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18565 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbYAKJGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:06:24 -0500
Date: Fri, 11 Jan 2008 10:06:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Smowton <cs448@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Splice(): exports for module programmers
Message-ID: <20080111090621.GH6258@kernel.dk>
References: <4786D7E5.2080701@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4786D7E5.2080701@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Chris Smowton wrote:
> Just a couple of quick questions if anyone can shed light regarding 
> functions exported for modules relating to splice():
> 
> * Is there a particular reason why the useful helper __splice_from_pipe 
> is exported, but not the locking equivalent splice_from_pipe or its 
> equally useful helper splice_to_pipe?
> * Similarly is there anything wrong with exporting the generic 
> pipe-buffer operations (e.g. generic_pipe_buf_map) to save effort 
> writing modules which implement splice_read and splice_write?
> 
> Are these unexported because they are unstable and not yet considered 
> suitable for use, or simply because nobody's written a module that 
> splice()s yet?

The latter, I generally don't export things until they are used.
__splice_from_pipe() wasn't exported until some file systems grew they
own splice implementations.

-- 
Jens Axboe

