Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYFRUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYFRUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFRUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:21:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51598 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYFRUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:21:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.450724863@theryb.frec.bull.fr>
Date: Wed, 18 Jun 2008 13:19:37 -0700
In-Reply-To: <20080618170731.450724863@theryb.frec.bull.fr> (Benjamin Thery's
	message of "Wed, 18 Jun 2008 19:08:59 +0200")
Message-ID: <m14p7qo5ra.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benjamin Thery <benjamin.thery@bull.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 09/11] sysfs: add sysfs_ns_exit routine
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery <benjamin.thery@bull.net> writes:

> Add sysfs routine sysfs_ns_exit() to allow a namespace to go away while
> sysfs is still mounted. 
>
> The exiting namespace calls this routine and pass it a callback to be 
> called for every sysfs superblocks present. The callback contains the 
> necessary code to clean the superblock tag data associated with this 
> namespace.

My apologies for not looking at this earlier.  This is a nice cleanup.
Thank you.

Eric
