Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbXFVRJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbXFVRJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXFVRJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:09:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37595 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbXFVRJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:09:17 -0400
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
From: Dave Hansen <hansendc@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:09:11 -0700
Message-Id: <1182532151.26162.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy and Joel, very cool that you got this in-tree!

I have a patch touching a bunch of fs ioctl functions.

Things like ext2_ioctl() look like this:

foo_ioctl()
{
	switch(ioctl) {
	case FOO:
		lots
		of
		code
	error:
		return result;
	case BAR:
		return result;
}

Notice that the "error:" label is indented.  Each of the case is kinda
like a mini function with its own variables and return statement.

Do you think it is worth teaching the patch checker about these?  It
seems pretty sane style to me.

Would we want to teach it that labels must be inside of brackets, or
should we have it look at the whole file to see if there precedent for
indented labels in the file?

-- Dave

