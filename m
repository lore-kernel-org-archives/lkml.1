Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYLLTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYLLTyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYLLTx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:53:59 -0500
Received: from nauticaltech.com ([64.34.252.43]:56717 "EHLO nauticaltech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYLLTx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:53:58 -0500
Message-ID: <4942BFC4.2030203@nauticaltech.com>
Date: Fri, 12 Dec 2008 11:47:16 -0800
From: Michael Spiegle <mike@nauticaltech.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [Bugme-new] [Bug 12201] New: long wait in call_usermodehelper()
 / queue_work() / wait_for_completion()
References: <bug-12201-10286@http.bugzilla.kernel.org/>	 <20081211143758.510b51b6.akpm@linux-foundation.org> <ac3eb2510812111448s7c700199ia2e57834f91c02a@mail.gmail.com>
In-Reply-To: <ac3eb2510812111448s7c700199ia2e57834f91c02a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you replace /sbin/modprobe in the kernel module loader, does the
> delay go away:
>   echo /bin/true > /proc/sys/kernel/modprobe

Yes, that does reduce the delay significantly.  The timing of the 
socket() call went from about 1500000us to 430000us.  This points the 
finger at modprobe it seems?

Michael Spiegle
mike@nauticaltech.com
