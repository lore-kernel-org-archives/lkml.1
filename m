Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbZFMP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbZFMP04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZFMP0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:26:48 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59111 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbZFMP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tg5WtuQYYQ7RnirBPwrZ6u8hgTf9xZRTeLD579EzZYTpGZ2E0zY/HhCq92Lbuw2KH0
         mggRXFkCQlVQxNHM6YBp+1QG6LtDyMIaTH3MJqKr3YPt4ZALFJlUEQMI/7o+iPdFnW+1
         Muxu57pB5XCp1BD3a9xu/kGGR25mSi0hJ9Paw=
Date: Sat, 13 Jun 2009 17:26:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] perfcounters: Print the filename:line for
	annotated colored lines
Message-ID: <20090613152644.GA4911@nowhere>
References: <1244906732-7521-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244906732-7521-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 05:25:31PM +0200, Frederic Weisbecker wrote:
> When we have a colored line in perf annotate, ie a middle/high
> overhead one, it's sometimes useful to get the matching line
> and filename from the source file, especially this path prepares
> to another subsequent one which will print a sorted summary of
> midle/high overhead lines in the beginning of the output.
> 
> Filename:Lines have the same color than the concerned ip lines.
> 
> It can be slow because it relies on addr2line. We could also
> use objdump with -l but that implies we would have to bufferize
> objdump output and parse it to filter the relevant lines since
> we want to print a sorted summary in the beginning.
> 
> Changes in v2:
> - fix addr2line on userspace binary
> - fix string allocation size (missing ending null char room)
> - fix overflow in symbol extra info
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


Forgot to put "v2" in the [PATCH] token. It fixes what you reported
Ingo, and also some other things.

Thanks.

