Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbXEAWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbXEAWk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXEAWk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:40:28 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38700 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498AbXEAWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:40:27 -0400
Message-ID: <4637C14F.3050702@vmware.com>
Date: Tue, 01 May 2007 15:38:07 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Marcos Pinto <markybob@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: VMware, x86_64 and 2.6.21.
References: <62eb359a0704302350m5e639c17t8517865c885c9ba9@mail.gmail.com>
In-Reply-To: <62eb359a0704302350m5e639c17t8517865c885c9ba9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcos Pinto wrote:
> I'm having the same problem.  I think it has to do with timer problems...
> Does /sbin/hwclock --show freeze your box?  It "sometimes" works on
> mine, but it  more often than not locks it hard (especially as user,
> not root) with no hints in syslog or anywhere else as to what
> happened.  This is a turion x2 with nvidia mcp51

/sbin/hwclock freezes the whole box for me turion x2 with nvidia mcp51 
(HP Pavillion dv9210us), but only when syncing hwclock to system time.  
I suspect it could be a hwclock IOPL bug, but I will have to check 
source to be sure.  But I see this with 2.6.20 Gentoo kernel, not just 
2.6.21, so I think it is a different bug.

Zach
