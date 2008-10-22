Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYJVVOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYJVVOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYJVVOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:14:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36540 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYJVVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:14:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>, netdev <netdev@vger.kernel.org>,
       Dave Miller <davem@davemloft.net>, Al Viro <viro@ftp.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>
References: <20081022152144.351965414@theryb.frec.bull.fr>
	<20081022201601.GC24959@suse.de>
Date: Wed, 22 Oct 2008 14:08:26 -0700
In-Reply-To: <20081022201601.GC24959@suse.de> (Greg KH's message of "Wed, 22
	Oct 2008 13:16:01 -0700")
Message-ID: <m17i80l4mt.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0169]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/4][RFC] netns: sysfs: add a netns suffix to net device sysfs entries
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, Oct 22, 2008 at 05:21:44PM +0200, Benjamin Thery wrote:
>> Network devices from sub-network namespaces appear in sysfs
>> with a name that looks like this: device_name@netns_id
>> eg: lo@3, eth0@4e
>
> How does the default udev rules as shipped by most distros handle the
> renaming of the network device if the MAC address is duplicated like it
> will be for these eth devices?

The mac address is not duplicated.

Further devices like eth0@4e are completely unusable to the udev
rules in the initial network namespace because they can not talk
to or affect them.

As I read it Ben's ``solution'' puts entries in sysfs that are
completely unusable to udev.

Eric

