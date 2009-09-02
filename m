Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIBOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIBOgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZIBOgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:36:35 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:59611 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZIBOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:36:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Tej <bewith.tej@gmail.com>
Subject: Re: [BUG-rc8]: Kernel bootprocess
Date: Wed, 2 Sep 2009 16:36:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
References: <f1c9d250909020545x90c3610nb75c0716cdf4d440@mail.gmail.com>
In-reply-To: <f1c9d250909020545x90c3610nb75c0716cdf4d440@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021636.35796.elendil@planet.nl>
X-OriginalArrivalTime: 02 Sep 2009 14:36:36.0850 (UTC) FILETIME=[C69CA520:01CA2BDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tej wrote:
> Recently upgraded to 2.6.3-rc8. While doing I could not able to boot,
> and boot process stop at dmesg saying something:
> ADDR_CONF (NETDEV CHANGE): eth0 interface become ready.
> 
> message seems success only but affter pressing alt+ctl+del. machine
> boot without xserver and complete / with readonly filesystem. So I
> couldn't capture whole dmesg.
> 
> Now: I have bisected the problem (twice), and bisect result goes to
> 0db501bd0610ee0c0aca84d927f90bcccd09e2bd is first bad commit
> Author: Eric W. Biederman <ebiederm@xmission.com>
>     inotify: Ensure we alwasy write the terminating NULL.

Can you try with the current git mainline, or current snapshot kernel? 
There have been a couple of inotify fixes committed since rc8.

Cheers,
FJP
