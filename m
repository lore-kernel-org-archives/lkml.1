Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYEND1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYEND1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 23:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYEND1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 23:27:33 -0400
Received: from imo-m21.mx.aol.com ([64.12.137.2]:39871 "EHLO
	imo-m21.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYEND1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 23:27:32 -0400
Message-ID: <482A5C19.6090503@aol.com>
Date: Tue, 13 May 2008 23:27:21 -0400
From: AndrewL733 <AndrewL733@aol.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Macbook Pro SATA Drives not seen in 2.6.25
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AOL-IP: 207.180.154.47
X-Mailer: Unknown (No Version)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple of Macbook Pros. The newest one -- based on the Penryn 
Core 2 Duo with ICH8 -- will not boot with any 2.6.25 kernel (I have 
tried 2.6.25 and 2.6.25.3). It boots fine with 2.6.24.7 as well as with 
2.6.26-rc2. It also boots fine with 2.6.22. I have specific reasons why 
I need to run 2.6.25 so I would appreciate any help here. It seems the 
SATA drives are detected, but then for each partition during bootup I see:

ata3: SATA link down (SStatus 0 SControl 0)

The same 2.6.25 kernels boot fine on my older Macbook Pro with ICH7 and 
I do not see this error.

I would be happy to run a git bisect to help identify the issue, but if 
this problem is already well understood (hey, it's fixed in 2.6.26), I 
can think of better ways to spend my time.

Please copy me personally on any replies. I often subscribe to the list 
but it's too much mail right now. Thanks in advance.

Andrew


