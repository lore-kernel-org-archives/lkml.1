Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZDTNBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZDTNBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZDTNA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:00:56 -0400
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:38029 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZDTNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:00:56 -0400
Message-ID: <49EC7200.9080308@Calva.COM>
Date: Mon, 20 Apr 2009 15:00:48 +0200
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Am I allowed to call request_firmware_nowait from an interrupt
 handler?
References: <49EC60BC.1070501@Calva.COM> <87ab6bpmc8.fsf@basil.nowhere.org>
In-Reply-To: <87ab6bpmc8.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> John Hughes <john@Calva.COM> writes:
>   
>> Am I being a naughty boy?
>>     
>
> Yes.
>
>   
Buggeration.  What an irritating restriction.

So I'll have to make a thread to do the firmware download, in which case 
I can just use request_firmware instead of request_firmware_nowait.

Or can I use schedule_work?

