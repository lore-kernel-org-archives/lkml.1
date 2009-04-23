Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZDWXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZDWXbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZDWXbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:31:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37150 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZDWXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:31:06 -0400
To: "Alexander V. Lukyanov" <lav@netis.ru>
Cc: linux-kernel@vger.kernel.org, <netdev@vger.kernel.org>
References: <20090422055735.GA4334@night.netis.ru>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 23 Apr 2009 16:30:57 -0700
In-Reply-To: <20090422055735.GA4334@night.netis.ru> (Alexander V. Lukyanov's message of "Wed\, 22 Apr 2009 09\:57\:35 +0400")
Message-ID: <m1hc0fuevi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: lav@netis.ru, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Alexander V. Lukyanov" <lav@netis.ru>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0245]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: 2.6.29.1: unregister_netdevice problem
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander V. Lukyanov" <lav@netis.ru> writes:

> Eventually I have an increased load average without apparent reason.
> When I reboot the server in such a case, I get infinitely repeating
> messages on the console:
>
> unregister_netdevice: waiting for eth0.2 to become free. Usage count = 4
>
> eth0.2 is a vlan interface, eth0 is 02:00.0 Ethernet controller: Realtek
> Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet
> controller (rev 01)

CC: netdev where someone might have a better clue.

Infinitely repeating unregister_netdevice messages means something
isn't releasing it's reference count to your network device.

There really isn't enough information in your email to figure out
what you were doing that, or what piece of code triggered this.

Eric
