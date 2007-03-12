Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXCLTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXCLTnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXCLTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:43:11 -0400
Received: from station18k.dscga.com ([192.24.222.18]:49188 "EHLO
	suzuka.mcnaught.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXCLTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:43:10 -0400
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RSDL for 2.6.21-rc3- 0.29
References: <20070311013506.GD10459@waste.org>
	<200703121428.29947.gene.heskett@gmail.com>
	<87wt1mjo4q.fsf@suzuka.mcnaught.org>
	<200703121510.18268.gene.heskett@gmail.com>
From: Douglas McNaught <doug@mcnaught.org>
Date: Mon, 12 Mar 2007 15:43:09 -0400
In-Reply-To: <200703121510.18268.gene.heskett@gmail.com> (Gene Heskett's
 message of "Mon, 12 Mar 2007 15:10:18 -0400")
Message-ID: <87slcajliq.fsf@suzuka.mcnaught.org>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> writes:

> On Monday 12 March 2007, Douglas McNaught wrote:
>>Gene Heskett <gene.heskett@gmail.com> writes:
>>> I'd considered it, but with 32 dle entries, the whole strace output
>>> would be terrabytes & I don't have THAT much disk.  Not to mention it
>>> traces only the parent process, so tar would be merrily marching along
>>> to its own drummer and not traced I'm  afraid.
>>
>>$ strace -ff
>>
>>-Doug
>
> Someone else suggested the single -f, and I tried that, but even with the 
> shell history set for 100,000 lines, i can't get back to the start, and I 
> think its mucking with the shell arguments numbering as what I can see is 
> about 5 reads through /etc/services accompanied by endless complaints 
> of -EBADFD, the the logfile it generates says the port it was given was 
> rejected when amcheck was run, here is that snip:

I'd do 'strace -ff -o /tmp/amanda-strace <command>', which will give
you a set of files in /tmp, one for each PID created by fork().  Then
find the one that has the 'tar' invocation you're looking for.

-Doug
