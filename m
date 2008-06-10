Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYFJCvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYFJCvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYFJCvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:51:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:25982 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYFJCvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ApxKlbIsR+6fyvJARZ+qJBeM/hSeZteTSKc3Ukp6W6icJbUUydXfgC/O1VVoqTSJdX
         xrExUTESsDDpUUCzuLJNFSMOWyh0g+XL7JCyPV9csQFv7/CAH+xmBb/nll0PJ/Ijn1vD
         GM9iGV+mfAiWg/hY9Jc78RQLtRzR6LQvrN06o=
Message-ID: <484DEC2C.2090207@gmail.com>
Date: Tue, 10 Jun 2008 11:51:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] expand link_power_management_policy definition
References: <20080603172307.1b963aac@appleyard> <4845E761.2090604@garzik.org>
In-Reply-To: <4845E761.2090604@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Kristen Carlson Accardi wrote:
>> I think I mentioned on the list a couple weeks ago that I favor just
>> expanding the definition of link power management to include
>> the notion of simply powering the entire port off rather
>> than adding new knobs to sysfs.  I wrote this completely untested and
>> very incomplete patch to give you a better idea of what I am proposing.
>> This patch adds a new valid value of "power_off" for the existing
>> link_power_management_policy sysfs entry:
> 
> Looks fine to me...  that would work nicely.
> 
> I think your patch is missing code to handle the transition from
> power_off to <something else>, though, right?
> 
> I'm quite happy with this approach.

I agree this is the right place to implement the control.

Thanks.

-- 
tejun
