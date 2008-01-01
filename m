Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYAAPek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYAAPek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYAAPec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:34:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58086 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbYAAPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:34:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SAt1VzhrF2M8oCMWFCt/0XamsfFQjeN7luMLWLYS+NZAewbrd+izYQ5nPX4e8pmjtSc2VQQiyo0mEpVZejl7CjLo8+sTO9SiEh59Eu0yXTj1z7SIwt9kDqFnTY4Oq+0ZvyzMr6PpUQN1g/xfqUj7zYgSBrVi5gRprcMMB9uL3E8=
Date: Tue, 1 Jan 2008 18:34:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] get rid of checkpatch.pl complains on apm_32.c
Message-ID: <20080101153424.GF7937@cvg.cvg>
References: <20071231204753.GA7411@cvg.cvg> <20080101150054.GB4434@elte.hu> <20080101151112.GC7937@cvg.cvg> <20080101152931.GH4434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101152931.GH4434@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Jan 01, 2008 at 04:29:31PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > damn me! *really* sorry for this.
| 
| nah, this happens all the time for me too - that's why i run a script 
| over cleanup patches.
| 

yep, but i don't want to put additional work on developers so i must
review the patches i'm sending *several* times at least! so that is my
fault ;)

| > Ingo, do you use some script for this checking? if yes - could you 
| > share it? ;) (i think it's not really hard to write myown, but your 
| > one is really preferred ;)
| 
| sure, pick up the script from:
| 
|  http://redhat.com/~mingo/misc/q-size-obj-compare
| 
| it depends on having the patch in a quilt queue. (and it's really sucky, 
| no error checking, etc.)
| 
| just run it - it picks up a modified .c file and compares that. If you 
| modify multiple files and want to check another one, give that file as 
| an argument to the script.
| 
| 	Ingo
| 

thanks, Ingo.

		- Cyrill -
