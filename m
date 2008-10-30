Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYJ3TEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYJ3TEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYJ3TEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:04:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbYJ3TEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:12 -0400
Message-ID: <490A0524.70406@redhat.com>
Date: Thu, 30 Oct 2008 20:04:04 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Wesley Leggette <wleggette@kaylix.net>
CC: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Kernel panic in kcryptd
References: <C56C1A70-4E26-4D12-A1BC-4E744BCD51C5@kaylix.net> <4909FD3E.8070104@redhat.com> <E025C369-CBA8-4EE7-8C21-5A7110EDD829@kaylix.net> <F18563A1-0A44-4790-A2AA-68D1A60030E6@kaylix.net>
In-Reply-To: <F18563A1-0A44-4790-A2AA-68D1A60030E6@kaylix.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wesley Leggette wrote:
>> Snapshots involved in LVM
>>>
>>> Is it reproducible without snapshots involved?
>> Will try. I'm trying to reproduce right now without "bigmem", but  
>> will stop if that is likely not the case.
>>
> 
> Also, I should mention that I'm trying this now (without bigmem) on a  
> logical volume that doesn't have snapshots. Would this make a  
> difference even if there are other lv's with snapshots (if they are  
> not being used)?

I think that if there is no IOs running over snapshots, it should be ok
for the first try. There is too many layers involved...
Maybe it is related to to http://bugzilla.kernel.org/show_bug.cgi?id=11636

Milan
