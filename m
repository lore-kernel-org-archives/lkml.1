Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZILQzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZILQzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 12:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZILQy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 12:54:57 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:36841 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZILQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 12:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nUthkpzUX7fw70UTEYEiWbr1MvD/VC4xrArOuesRkS4CUojHNg/Ywv3JTTorwWcv9W
         2JE+OH3CIt2082RiFTnj+P4mZ7f61/eHSFHLXWNMoSsgRSfSmJwAjr3+GhBqL7pyRm8J
         /JsVSr4dXkVbnm78YJH09uTmivSqq1SKhfitI=
Message-ID: <4AABD260.1000708@gmail.com>
Date: Sat, 12 Sep 2009 10:54:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Anil kumar <anils_r@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: hibernate takes long time with huge file transfers
References: <12538.96333.qm@web32408.mail.mud.yahoo.com>
In-Reply-To: <12538.96333.qm@web32408.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 12:04 PM, Anil kumar wrote:
> Hi,
>
> I am running a huge file transfer by using simple dd command. I see that the process state of this dd is "D" uninterruptible sleep. Now I hibernate the system.
>
> what I observe is that hibernate takes long time to complete. Looks like its waiting for the "dd" command to complete.
> My understanding is that since the process is in uninterruptible sleep, hibernate is not able to stop the task.
>
> Question:
> 1. Does hibernation work this way wherein it waits for the process to complete and then hibernate. Especially if the process is in uninterruptible sleep state.
> 2. What if the process is not in uninterruptible sleep?

I don't imagine the fact it's in D state would have anything to do with 
it, more likely that it's constantly generating writes and the 
hibernation process does a sync, which may take a long time if something 
is dirtying memory as fast it can be written out..

> 3. Does sync'ing also adds to longer durations?
>
> Thanks in advance for the help.
>
> With regards,
>     Anil
>
>
>

