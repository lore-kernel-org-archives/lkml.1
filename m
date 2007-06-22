Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXFVSCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXFVSCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbXFVSCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:02:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58588 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868AbXFVSCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:02:13 -0400
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
From: Dave Hansen <hansendc@us.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
In-Reply-To: <467C0CE9.5010502@austin.ibm.com>
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>
	 <1182532151.26162.45.camel@localhost>  <467C0CE9.5010502@austin.ibm.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 11:02:10 -0700
Message-Id: <1182535330.26162.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 12:54 -0500, Joel Schopp wrote:
> If it is "kinda like a mini function" why not make it "actually a mini
> function" and call it? 

Several of our on-disk filesystems have an ioctl function that already
has indented goto labels.  I don't think it's quite worth churning all
of these (working) filesystems to make a style checker happy.

I think it's worse style to be mixing label indentation in a file as it
is to create new "correct" indentation labels.  That's why I suggested
using context in the file to determine it rather than absolute rules.

-- Dave

