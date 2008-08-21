Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbYHUSYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbYHUSYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYHUSYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:24:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49715 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYHUSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:23:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
References: <1218865985-23403-1-git-send-email-andi@firstfloor.org>
	<m1myj63neb.fsf@frodo.ebiederm.org>
	<20080821064009.GB18831@one.firstfloor.org>
Date: Thu, 21 Aug 2008 11:15:37 -0700
In-Reply-To: <20080821064009.GB18831@one.firstfloor.org> (Andi Kleen's message
	of "Thu, 21 Aug 2008 08:40:09 +0200")
Message-ID: <m163pus08m.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Move sysctl check into debugging section and don't make it default y
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> What is a feature change like this doing coming in after the
>> merge window?
>
> I considered it a "anti bloat bugfix". Adding 30k of 
> object code to allno was a bit too much. 

30k???  Which platform are you testing on ia64????

On x86_64 it is 8k text and 8k data.

Eric
