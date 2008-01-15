Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYAOPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYAOPLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYAOPLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:11:04 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:47394 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYAOPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:11:01 -0500
Message-ID: <478CCC9C.4070507@emc.com>
Date: Tue, 15 Jan 2008 10:09:16 -0500
From: Ric Wheeler <ric@emc.com>
Reply-To: ric@emc.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Abhishek Rai <abhishekrai@google.com>, linux-kernel@vger.kernel.org,
       rohitseth@google.com, linux-ext4@vger.kernel.org
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
 patch]
References: <200801140839.01986.abhishekrai@google.com>	<20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org>
In-Reply-To: <20080115030441.a0270609.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CP_NAME_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'm wondering about the real value of this change, really.
> 
> In any decent environment, people will fsck their ext3 filesystems during
> planned downtime, and the benefit of reducing that downtime from 6
> hours/machine to 2 hours/machine is probably fairly small, given that there
> is no service interruption.  (The same applies to desktops and laptops).
> 
> Sure, the benefit is not *zero*, but it's small.  Much less than it would
> be with ext2.  I mean, the "avoid unplanned fscks" feature is the whole
> reason why ext3 has journalling (and boy is that feature expensive during
> normal operation).
> 
> So...  it's unobvious that the benefit of this feature is worth its risks
> and costs?

I actually think that the value of this kind of reduction is huge. We 
have seen fsck run for days (not just hours) which makes the "restore 
from backup" versus "fsck" decision favor the tapes...

ric
