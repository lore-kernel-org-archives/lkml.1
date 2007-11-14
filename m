Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXKNL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXKNL6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXKNL6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:58:22 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:1736 "EHLO
	smtp2.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753090AbXKNL6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:58:21 -0500
Message-ID: <473AE2CC.4080609@draigBrady.com>
Date: Wed, 14 Nov 2007 11:58:04 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about free/used memory on Linux
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com> <471BA1D1.5040905@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847C@xmb-sjc-214.amer.cisco.com> <471C3A17.5020400@linux.vnet.ibm.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3024B859E@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B859E@xmb-sjc-214.amer.cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Nov 2007 11:58:12.0318 (UTC) FILETIME=[A1A8A7E0:01C826B5]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXSweep-spf: None
x-MXPurifier-SpamScore: 5
x-MXPurifier-VirusScore: 0
X-MXUniqueID: 9db1d281-ffb1-4e01-a41d-b3b23ae921c8
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> Hi Vaidy,
> What do you think is the right way to get the memory usage of a
> process, I mean the actual physical memory used ? Basically,
> I'm interested in the incremental cost of a process, which
> means, I don't want to include the text segments of shared
> libraries which would remain even after the process is killed
> (since it would be used by other processes).
> 
> Is the RSS field of "ps aux" command the right one or use 
> "pmap" command and look at the "writeable" segments ?

I already commented on this thread with a python script
for reporting RAM usage for programs.

RSS = Private and Shared Resident pages.
You can get the shared value for a process from /proc/$$/smaps
(as is done in the script)

Pádraig.
