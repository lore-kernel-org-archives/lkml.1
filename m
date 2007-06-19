Return-Path: <linux-kernel-owner+w=401wt.eu-S1765722AbXFSULY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765722AbXFSULY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761956AbXFSULK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:11:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761242AbXFSULH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:11:07 -0400
Message-ID: <46783847.1020205@redhat.com>
Date: Tue, 19 Jun 2007 16:10:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <467829C4.5020101@zytor.com> <46782AA5.2000108@hawkeye.stone.uk.eu.org>
In-Reply-To: <46782AA5.2000108@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> H. Peter Anvin wrote:
>> Chris Snook wrote:
>>> I pointed out NetApp's .snapshot directories because that's a method
>>> that uses legal path character, but doesn't break anything.  With this
>>> method, userspace tools will have to be taught that : is suddenly a
>>> special character.
>> Not to mention that the character historically used for this purpose is
>> ; (semicolon.)
> 
> But that would cause havoc with shells which use ; to seperate commands.
> Using ; would defiantly break userspace
> 
> Jack
> 

I can escape the semicolon just fine in bash.  In fact, tab-completion will do 
this automatically.  That's really a non-issue.  It just means that anyone who 
wants to use this feature would have to know what they're doing, which I believe 
is your goal, right?

	-- Chris
