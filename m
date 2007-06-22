Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXFVS0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXFVS0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbXFVS0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:26:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35790 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbXFVS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:26:15 -0400
Message-ID: <467C1233.5030609@austin.ibm.com>
Date: Fri, 22 Jun 2007 13:17:23 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>	 <1182532151.26162.45.camel@localhost>  <467C0CE9.5010502@austin.ibm.com> <1182535330.26162.50.camel@localhost>
In-Reply-To: <1182535330.26162.50.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Several of our on-disk filesystems have an ioctl function that already
> has indented goto labels.  I don't think it's quite worth churning all
> of these (working) filesystems to make a style checker happy.
> 
> I think it's worse style to be mixing label indentation in a file as it
> is to create new "correct" indentation labels.  That's why I suggested
> using context in the file to determine it rather than absolute rules.

If it is bad coding style that is justified because there is already other bad coding 
style to match -- that is not a judgment call for a script to make, but for a real 
person to make.

There is no law that says you have to fix 100% of the warnings the script generates, 
even if they are valid warnings.  You'd just better be ready to justify them is all. 
  Your justification seems reasonable in this case -- it is worse to mix right and 
wrong label indentation vs indenting wrongly but consistently.

Indent consistently wrong and feel happy about it, just don't expect the style 
checker to give you a free pass when you perpetuate somebody else's wrong.  If we 
start down the path of bad coding style always being OK if there is already bad 
coding style around it I think that is a slippery slope.  There should be some 
friction when we perpetuate bad style so there is some incentive to fix the style for 
future generations to be able to read our code better.

