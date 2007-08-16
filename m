Return-Path: <linux-kernel-owner+w=401wt.eu-S1764610AbXHPXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764610AbXHPXMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXHPXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:12:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXHPXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:12:15 -0400
Message-ID: <46C4D9C2.9020000@zytor.com>
Date: Thu, 16 Aug 2007 16:12:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Valdis.Kletnieks@vt.edu, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <763705.7247.qm@web52512.mail.re2.yahoo.com>
In-Reply-To: <763705.7247.qm@web52512.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> Yep - way outside the box - and thus the title of the
> thread.
> 
> The idea is that people have permissions - not files.
> By people I mean users, groups, managers, applications
> etc. One might even specify that there are no
> permission restrictions at all. Part of the process
> would be that the kernel load what code it will use
> for the permission system. It might even be a little
> perl script you write.

This isn't anything new.  It is, in fact, described in many places.

Permissions can, most generally, be described as a matrix of objects and
security domains.  This matrix is large and, generally, highly regular.
 If we slice the matrix up and associate each column with an object, we
call it an "access control list".  If we slice the matrix up and
associate each row with a security domain, we call it a "capability."

These can be, and often are, daisy-chained, so that an access control
list can contain "all possessors of capability X", for example.

Groups in Unix are, in fact, a form of capabilities.

	-hpa

