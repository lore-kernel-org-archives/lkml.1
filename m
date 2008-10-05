Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYJEKep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYJEKep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYJEKeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:34:37 -0400
Received: from gw-ca.panasas.com ([66.104.249.162]:13429 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbYJEKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:34:37 -0400
Message-ID: <48E89839.5030307@panasas.com>
Date: Sun, 05 Oct 2008 12:34:33 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, lists@ku-gbr.de
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org>
In-Reply-To: <48E8947A.5020608@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Oct 2008 10:33:28.0982 (UTC) FILETIME=[CE6BA360:01C926D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 05, 2008, 12:18 +0200, Tejun Heo <tj@kernel.org> wrote:
> Benny Halevy wrote:
>> On Sep. 24, 2008, 12:36 +0300, Tejun Heo <tj@kernel.org> wrote:
>>> Please apply the attached patch and post the resulting log.  Please
>>> don't forget to turn on KALLSYMS.
>>>
>>> Thanks.
>>>
>> With commit 4c1eb90a0908c0c60db2169dce08fb672e7582f1 (v2.6.27-rc8),
>> I see no spurious EH complete events as I saw with 2.6.27-rc <= 7.
> 
> You're on CK804, right?
> 

No, MCP55 actually:

$ lspci | grep IDE
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
