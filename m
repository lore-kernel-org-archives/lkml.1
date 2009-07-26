Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbZGZEKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbZGZEKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 00:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZGZEKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 00:10:44 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:34403 "EHLO kirsi2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZGZEKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 00:10:44 -0400
Message-ID: <4A6BD741.2070807@trn.iki.fi>
Date: Sun, 26 Jul 2009 07:10:41 +0300
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+bpsk@trn.iki.fi>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Securing a system with limits.conf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is off-topic for linux-kernel but here it goes...

After doing some research (Googling, checking Hardening Linux, Essential 
System Administration and a number of other books) I was quite shocked 
that configuring the limits doesn't seem to be documented anywhere. 
Sure, they all list the information that can be acquired by ulimit -a or 
man limits.conf but those oneliner descriptions of options fail to describe:

- What does the setting actually limit (one can find what the data 
segment or a core file is by Googling but it would be nicer if the 
documentation listed the security implications of each setting).

- What is the scope of the limit: per-user, per-process, all descendants 
of the current process, ...?

- How should things be configured to reliably prevent non-priveleged 
users from DoS'ing a machine.

Is there possibly some documentation that I have not found or is there 
actually a huge gap in the essential security documentation here?

Thanks.
