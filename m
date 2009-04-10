Return-Path: <linux-kernel-owner+w=401wt.eu-S1765243AbZDJLIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765243AbZDJLIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZDJLIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:08:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7984 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZDJLIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aZwb31v5MwNnnryfVTfS2EIDuYrbKyi39uHh4GJej3kj0rOWPB1LTdACEVouqjRBFL
         ENUuu/hFuAlHbwsmCUGnDgQA/FgA2edfKkgJWlAB+qikoLdaVumXzOZME03xACMwnRcn
         HhVnEds9J9/eG3BsEt6pJG1YvP1ibcqkXv8SA=
Message-ID: <49DF289D.5070604@tuffmail.co.uk>
Date: Fri, 10 Apr 2009 12:08:13 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Regression: First hibernation attempt fails
References: <49DDD83F.507@tuffmail.co.uk> <20090410092318.GB30093@elf.ucw.cz>
In-Reply-To: <20090410092318.GB30093@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2009-04-09 12:13:03, Alan Jenkins wrote:
>   
>> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
>> wonder if it rings any bells?
>>
>> On my laptop (EEE 4G), the first attempt at hibernation fails. 
>> Subsequent attempts succeed.
>>
>> If I use s2disk as normal, I see "snapshotting system", then before it
>> gets to write out the image, it aborts and switches back to X.   I can't
>> see any error message, even if I check the log with "dmesg".
>>
>> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
>> allocate memory".
>>
>> This only happens if I've logged in to X first.  In fact, I narrowed it
>> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
>> then it doesn't happen.
>>     
>
> Anything interesting in dmesg?
>   

Nothing obvious. I've attached my latest at
<http://bugzilla.kernel.org/show_bug.cgi?id=13058>.

Regards
Alan
