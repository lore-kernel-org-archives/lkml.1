Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYG3AbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYG3AbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYG3AbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:31:08 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:39204 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbYG3AbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:31:07 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console on slackware 12.1
Date: Wed, 30 Jul 2008 10:30:29 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <ntcv845p7kpiob7iqf6d1m8buj116ug4nv@4ax.com>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com>
In-Reply-To: <488FAFE3.4040001@am.sony.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 17:03:47 -0700, Tim Bird <tim.bird@am.sony.com> wrote:

>Marco Berizzi wrote:
>> alistair@devzero.co.uk wrote:
>> 
>>> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?
>> 
>> yes console_translation is set to yes. It cannot be changed if embedded is not
>> set.
>
>If console_translation is set to yes, the behavior should be unchanged from
>2.6.26.  Can you please send me your .config?
>
>Also, can you please describe what breakage you are seeing?

I have the same issue, the line drawing characters are displayed as an odd 
looking C with a tail.  Slackware-12.1 and Slamd64-12.1.

.configs:
  http://bugsplatter.mine.nu/test/boxen/pooh/config-2.6.27-rc1a.gz
  http://bugsplatter.mine.nu/test/boxen/pooh64/config-2.6.27-rc1a.gz

CONFIG_CONSOLE_TRANSLATIONS=y ?? yes it's on

Grant.
