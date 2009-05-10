Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZEJHxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZEJHxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZEJHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:53:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49071 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZEJHxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:53:07 -0400
To: David Miller <davem@davemloft.net>
Cc: cfriesen@nortel.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <4A049C6B.9070000@nortel.com>
	<20090508.143947.207466029.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 10 May 2009 00:53:03 -0700
In-Reply-To: <20090508.143947.207466029.davem@davemloft.net> (David Miller's message of "Fri\, 08 May 2009 14\:39\:47 -0700 \(PDT\)")
Message-ID: <m17i0pwg0w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cfriesen@nortel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] ipconfig: handle case of delayed DHCP server
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: "Chris Friesen" <cfriesen@nortel.com>
> Date: Fri, 08 May 2009 14:56:11 -0600
>
>> 
>> +	/* Is it a reply for the device we are configuring? */
>> +	if (b->xid != ic_dev_xid) {
>> +		if (net_ratelimit())
>> + printk(KERN_ERR "DHCP/BOOTP: Ignoring delayed packet \n");
>> +		goto drop_unlock;
>
> Please don't use such odd indentation for this printk
> statement.

Weird it looked ok in my mailer 3 tabs in, and out to coloumn 82.  Dave someting
word wrap it for you?

Eric
