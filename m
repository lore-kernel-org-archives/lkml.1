Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbXLWHR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbXLWHR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXLWHRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:17:17 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55094 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbXLWHRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:17:17 -0500
X-Sasl-enc: OjZGo6A6Th3UU3oamzbZgFgJfKCzT+YxSpUrzfQs8z3n 1198394235
Cc: linux-kernel@vger.kernel.org
Message-Id: <838DE9A2-59B2-49FA-B3E8-89B26368B1CF@bluecamel.eml.cc>
From: Scott <linux-kernel@bluecamel.eml.cc>
To: Gianluca Alberici <gianluca@abinetworks.biz>
In-Reply-To: <476CEC5E.9070002@abinetworks.biz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: NFS EINVAL on open(... | O_TRUNC) on 2.6.23.9
Date: Sun, 23 Dec 2007 02:17:21 -0500
References: <476CEC5E.9070002@abinetworks.biz>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 22, 2007, at 5:52 AM, Gianluca Alberici wrote:
> I've run into this problem 2.6.23.9. The open syscall will return
> "Invalid argument" when O_TRUNC is set on existing files.
>
> The same file can be opened for append or removed.
>
> The evidence is for example:
>
> mars:~# mount localhost:/opt/nfs/ /mnt/tmp
> mars:~# echo "Hello" > /mnt/tmp/test-file
> mars:~# echo "Hello" > /mnt/tmp/test-file
> bash: /mnt/tmp/test-file: Invalid argument

Can you show an strace of this please? Also, might suggest "rpcdebug - 
m nfsd -s all"

--
Scott 
