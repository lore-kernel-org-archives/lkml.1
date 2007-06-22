Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbXFVRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbXFVRzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXFVRyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:54:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59170 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXFVRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:54:52 -0400
Message-ID: <467C0CE9.5010502@austin.ibm.com>
Date: Fri, 22 Jun 2007 12:54:49 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky> <1182532151.26162.45.camel@localhost>
In-Reply-To: <1182532151.26162.45.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> foo_ioctl()
> {
> 	switch(ioctl) {
> 	case FOO:
> 		lots
> 		of
> 		code
> 	error:
> 		return result;
> 	case BAR:
> 		return result;
> }
> 
> Notice that the "error:" label is indented.  Each of the case is kinda
> like a mini function with its own variables and return statement.

If it is "kinda like a mini function" why not make it "actually a mini function" and 
call it?

I really don't like the indenting here.  When I first glanced over that code I 
thought "case FOO:", "case error:", "case BAR:".  Only later after reading your 
description did I realize error wasn't part of the switch, but an independent label.

> 
> Do you think it is worth teaching the patch checker about these?  It
> seems pretty sane style to me.

It hurts my eyes.  Not that I'm the coding style czar or anything, if I were the 
kernel coding style would be different in several ways.  But inasmuch as this is a 
democracy (which it isn't) then I am opposed to crazy indentation such as your example.





