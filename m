Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192Ab0AWSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0AWSvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 13:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925Ab0AWSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 13:51:40 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63701 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0AWSvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 13:51:39 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2010 13:51:39 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oous/V+kp42H3Fiv7GCjh+zExYwGPIGpc6VlAtg2BFMeb8WElz2CR8qtret2ayLlqA
         mkB3dhNeTExF02iXIj0dGpfZtrxlSFtC/8aBhsgdWEKLqBBtYb/yGJAtgqUtDWMSia4k
         lYuTHjy0oNirkRBUEHQWyQk8JhupvOahD8t3I=
MIME-Version: 1.0
In-Reply-To: <20100123090005.GA3897@brick.ozlabs.ibm.com>
References: <20100122102541.GA21430@xhl>
	 <20100123090005.GA3897@brick.ozlabs.ibm.com>
Date: Sat, 23 Jan 2010 12:44:40 -0600
Message-ID: <ab644e481001231044r34651f25y7f7a98b1d76d4f93@mail.gmail.com>
Subject: Re: [PATCH] perf: Replace the extended ASCII copyright char to normal 
	ASCII sequence
From: Steve McKay <shubalubdub@gmail.com>
To: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 3:00 AM, Paul Mackerras <paulus@samba.org> wrote:

> On Fri, Jan 22, 2010 at 06:25:41PM +0800, Li Hong wrote:
>
>> A copyright extended ASCII char (0xa9) in kernel/perf_event.c makes my utf-8
>> compatible vim think it is a binary file. It is better to either use a utf-8
>> sequence 0xc20xa9 or just normal copyright ASCII chars '(C)'.
>
> The trouble is, I've been informed that "(C)" has no legal meaning --
> it is not equivalent to the C-in-a-circle copyright symbol.  That's
> why I put the extended ASCII character in there.  I wouldn't mind the
> utf-8 sequence instead though.
>
> Paul.

>From the Copyright Law FAQ:

A proper copyright notice consists of three things: 1) the letter "C" in
a circle (called, logically enough, the "copyright symbol"), or the word
"Copyright," or the abbreviation "Copr."; 2) the year of first
publication; 3) the name of the copyright owner.  17 U.S.C. 401(b).

http://www.faqs.org/faqs/law/copyright/faq/part2/
http://www.copyright.gov/title17/92chap4.html

(C) and © appear to  be unnecessary if Copyright <year> <name> is
already present. IANAL, side effects may include, not intended to
diagnose, treat, or prevent, etc.
