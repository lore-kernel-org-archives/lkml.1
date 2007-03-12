Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXCLTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXCLTLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXCLTLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:11:36 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:49049 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXCLTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:11:35 -0400
Date: Mon, 12 Mar 2007 15:10:18 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
In-reply-to: <87wt1mjo4q.fsf@suzuka.mcnaught.org>
To: linux-kernel@vger.kernel.org
Message-id: <200703121510.18268.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <200703121428.29947.gene.heskett@gmail.com>
 <87wt1mjo4q.fsf@suzuka.mcnaught.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Douglas McNaught wrote:
>Gene Heskett <gene.heskett@gmail.com> writes:
>> I'd considered it, but with 32 dle entries, the whole strace output
>> would be terrabytes & I don't have THAT much disk.  Not to mention it
>> traces only the parent process, so tar would be merrily marching along
>> to its own drummer and not traced I'm  afraid.
>
>$ strace -ff
>
>-Doug

Someone else suggested the single -f, and I tried that, but even with the 
shell history set for 100,000 lines, i can't get back to the start, and I 
think its mucking with the shell arguments numbering as what I can see is 
about 5 reads through /etc/services accompanied by endless complaints 
of -EBADFD, the the logfile it generates says the port it was given was 
rejected when amcheck was run, here is that snip:

running /usr/local/sbin//amcheck Daily
Amanda Tape Server Host Check
-----------------------------
Holding disk /dumps: 72597 MB disk space available, using 72097 MB
slot 5: read label `Dailys-5', date `20070223002502'
NOTE: skipping tape-writable test
Tape Dailys-5 label ok
Server check took 4.556 seconds

Amanda Backup Client Hosts Check
--------------------------------
WARNING: coyote: selfcheck request failed: unable to bind to a reserved 
port (got port 32789)
Client check: 1 host checked in 34.733 seconds, 1 problem found

(brought to you by Amanda 2.5.1p3-20070222)
------------------eofsnip------------

The script quit by request shortly after as I didn't want it to further 
dirty the amanda database system.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Safety Third.
