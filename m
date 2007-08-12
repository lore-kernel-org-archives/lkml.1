Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXHLORd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXHLORd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 10:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbXHLORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:17:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53321 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758876AbXHLORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:17:24 -0400
Date: Sun, 12 Aug 2007 07:17:21 -0700
From: Paul Jackson <pj@sgi.com>
To: Fredrik Noring <noring@nocrew.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improving read/write/close system call reliability when used
 with pthreads
Message-Id: <20070812071721.f35d7373.pj@sgi.com>
In-Reply-To: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
References: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrik wrote:
> required-fds.patch (not sure Apple Mail can handle this properly  
> though...):

You suspected correctly - Apple Mail line wrapped it at 72 columns
(added newlines in any line going past column 72.)  This makes it
impossible to apply the patch without alot of hand editing.

As you probably also suspect (correctly, again), given the volume of
patches we handle on lkml, the burden is on the submitter to get the
patch format correct, so it applies cleanly.

You will have to experiment some, sending the patch to yourself and
being sure that it applies cleanly.  I'm not an Apple Mail expert, so
can't help; sorry.  Perhaps some other email program ...?


For example, this line wrapped:

fs/open.c                 |   63 +++++++++++++++++++++++++++++++++++++ 
+++++++++

and more critically, in the patch, many lines, such as:

+/* file descriptors required to complete current I/O operation  
successfully */
+	struct list_head required_fds;



-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
