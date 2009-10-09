Return-Path: <linux-kernel-owner+w=401wt.eu-S934664AbZJIWEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbZJIWEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZJIWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZJIWEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:04:12 -0400
Message-ID: <4ACFB337.8040109@redhat.com>
Date: Fri, 09 Oct 2009 17:03:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alexey Fisher <bug-track@fisher-privat.net>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 corruptions
References: <1255116014.3014.8.camel@mini> <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> [ adding some CCs so that this doesn't get lost in the lkml wilderness ]
> 
> On Fri, 9 Oct 2009, Alexey Fisher wrote:
> 
>> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
>> systems.
>> The symptoms:
>> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
>> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
>> bad things and will try to fix it. After this action is the system
>> unusable.
> 
> Does this happen also when you switch from vanilla 2.6.32-rcX to vanilla 
> 2.6.31, or only from vanilla 2.6.32-rcX to "Ubuntu 2.6.31"?
> 
>> Do any one had same problem? The is no sans to bisect it, after some
>> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
>> or fsck problem?
> 

Not sure if this is the same as
http://bugzilla.kernel.org/show_bug.cgi?id=14354 but it's similarly
lacking in useful info ;)

Please provide the fsck output, any kernel messages, etc ...

-Eric
