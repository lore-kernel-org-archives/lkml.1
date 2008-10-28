Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYJ1Ti5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYJ1Ti5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYJ1Tiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:38:46 -0400
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:45095 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbYJ1Tip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:38:45 -0400
Message-ID: <49076A36.5040802@vlnb.net>
Date: Tue, 28 Oct 2008 22:38:30 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
References: <4901F375.3020202@vlnb.net> <200810282342.05172.nickpiggin@yahoo.com.au>
In-Reply-To: <200810282342.05172.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Saturday 25 October 2008 03:10, Vladislav Bolkhovitin wrote:
>> Hi,
>>
>> During recent debugging session of my SCSI target SCST
>> (http://scst.sf.net) I noticed many
>>
>> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
>>
>> messages in kernel log on the initiator. I attached the full log of
>> several of them.
>>
>> My target was buggy and I was working on fixing it, but I suppose Linux
>> should handle such failures more gracefully. In all the cases the target
>> had one type of failure: it "ate" a SCSI command and never returned
>> result of it.
> 
> Right. This is one of the warnings I see in my fault-injection testing.
> It is fixed by my patch to clean up and improve the page and buffer
> error handling in the vm/fs.

Can you specify which patch you referring? Is it in 2.6.27?
