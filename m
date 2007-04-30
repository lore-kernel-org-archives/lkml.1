Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXD3XQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXD3XQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXD3XQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:16:05 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:54289 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXD3XQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:16:03 -0400
Message-ID: <463678A2.7060000@nortel.com>
Date: Mon, 30 Apr 2007 17:15:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: SMB2 file system - should it be a distinct module
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
In-Reply-To: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Apr 2007 23:15:49.0585 (UTC) FILETIME=[7D7CC410:01C78B7D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:

> ...we need to decide whether the kernel
> implementation of SMB2 client should be a distinct module or just part
> of the cifs.ko module.

<snip>

> My guess is that less than 1/3 of the cifs module would overlap - but
> that overlap is enough that it would be easier to do smb2 as part of
> cifs (although it would make the cifs module somewhat larger).

What about pulling out the common code into a helper module, which can 
then be used by both cifs and smb2?

Chris
