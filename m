Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZFSV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZFSV4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZFSV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:56:27 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:62586 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbZFSV40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:56:26 -0400
From: Frans Pop <elendil@planet.nl>
To: Andreas Sundstrom <sunkan@zappa.cx>
Subject: Re: 2.6.30 kernel panic when closing lid
Date: Fri, 19 Jun 2009 23:56:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A3BF368.9090103@zappa.cx>
In-reply-To: <4A3BF368.9090103@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906192356.28453.elendil@planet.nl>
X-OriginalArrivalTime: 19 Jun 2009 21:56:28.0968 (UTC) FILETIME=[CC8F0280:01C9F128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Sundstrom wrote:
> My laptop has started crashing when I close the lid. This does not
> happen with 2.6.29.4 which I was using before 2.6.30, I configured my
> 2.6.30 kernel with the 2.6.29.4 as the base and then did "make
> oldconfig" and then most of the questions I got I used the default
> setting.

That sounds like it may be a known issue, although it's somewhat strange 
that you did not see it with earlier kernels.
Can you test if the following workaround fixes the crash?

echo -n 7 >/proc/acpi/video/C09A/DOS

See e.g.: http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/01971.html
You can find more information by googling for "hp 2510p lid close crash"
(but it affects other models as well).

Cheers,
FJP
