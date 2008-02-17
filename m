Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbYBQXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbYBQXwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYBQXwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:52:01 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43815 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbYBQXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:51:59 -0500
Date: Mon, 18 Feb 2008 00:51:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
In-Reply-To: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0802180048320.26274@fbirervta.pbzchgretzou.qr>
References: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18 2008 00:21, Joerg Schilling wrote:
>
>> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the 
>> following error from wodim: 
>
>> Errno: 0 (Success), write_g1 scsi sendcmd: no error 
>> CDB:  2A 00 00 00 00 00 00 00 1F 00 
>> status: 0x2 (CHECK CONDITION) 
>> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00 
>> Sense Key: 0x5 Illegal Request, Segment 0 
>> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0 
>> Sense flags: Blk 0 (not valid) 
>> resid: 63488 
>
>This fragment is much too short to allow to judge on possible reasons.
>There is a high probability that your problem is caused by the cdrecord
>fork called "wodim".
>
[...]
>
>As a general advise: if you have problems, always first try recent original 
>software from

SUSE 10.3 users (and the OP seems to be one..) may use the 'cdrtools' 
RPM which I have in my repository (I don't like wodim either, but that's 
not the point here). Just !webpin for cdrtools.

(oh and please use reply-to-all/dont-strip-Ccs, thanks :)
