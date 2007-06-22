Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbXFVPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbXFVPE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXFVPEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:04:22 -0400
Received: from esuna.co.uk ([83.223.102.198]:56340 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752910AbXFVPEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:04:21 -0400
Message-ID: <467BE4F1.7040308@esuna.co.uk>
Date: Fri, 22 Jun 2007 16:04:17 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com>
In-Reply-To: <467BE118.4090308@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:

> On 06/21/2007 08:07 PM, Jay L. T. Cornwall wrote:
>> [  724.350222] general protection fault: 0000 [1] SMP
>> [  724.350413] CPU 1
>> <snip>
>> [  724.355028] Pid: 199, comm: pdflush Not tainted 2.6.22-rc5-edge #1
>> [  724.355125] RIP: 0010:[<ffffffff880f1b44>]  [<ffffffff880f1b44>]
>> :ext3:walk_page_buffers+0x34/0x90

> Step 1: run fsck on the filesystem.

Already done. The filesystem came back as clean after the first oops,
but I forced a recheck with fsck to be safe - it found no problems.

This is reproducible on a clean filesystem.

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
