Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYIBFqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYIBFqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIBFqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:46:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYIBFqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:46:22 -0400
Message-ID: <48BCD2DD.3040209@kernel.org>
Date: Tue, 02 Sep 2008 07:45:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <20080830205143.GA9726@anita> <48BBCF98.4070003@kernel.org> <20080901174657.GA2114@anita> <48BCC28E.5030009@kernel.org> <20080902054322.GA7154@anita>
In-Reply-To: <20080902054322.GA7154@anita>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 05:46:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Am 2008-09-02 06:35 +0200 schrieb Tejun Heo:
> 
>>> Seems this stuff is kinda new since 2.6.25?
>> I think it's more circa 2.6.22 but in my memory terms, which sucks,
>> that's a lifetime before so I don't really remember.  :-)
> 
> Okay :-)
> 
>> Hmm... someone is scheduling EH incessantly without any error or action
>> set.  Can you please try the attached patch?
> 
> I did and put here all dmesg gave me. Do you want to get the whole stuff
> from the beginning? /var/log/messages has ist, but it is 416k, I put it
> on a ftp server somewhere out there then. Or is something else
> recommended?

The excerpt is fine but please turn on CONFIG_KALLSYMS.  The stack dump
is pretty much meaningless without it.

Thanks.

-- 
tejun
