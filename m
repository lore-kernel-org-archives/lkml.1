Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXLPLbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXLPLbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765071AbXLPLbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:31:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37852 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761184AbXLPLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:31:08 -0500
Message-ID: <47650C88.6040105@davidnewall.com>
Date: Sun, 16 Dec 2007 22:01:20 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
References: <20071216080441.435456586@I-love.SAKURA.ne.jp>	<20071216080628.061470932@I-love.SAKURA.ne.jp>	<200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>	<200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>	<47650A4C.4000708@davidnewall.com> <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
In-Reply-To: <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> David Newall wrote:
>   
>> Tetsuo Handa wrote:
>>     
>>>  /dev needs to be writable, but this means that files on /dev might be
>>>  tampered with.
>>>       
>> I infer that you mean /dev needs to be writable by anyone, not by just 
>> its owner or owner and group (conventionally root/root.)  This goes 
>> against conventional wisdom, which is that /dev must be writable only by 
>> the administrator.  Why do you say otherwise?
>>     
> I didn't mean that "/dev is writable by everybody".
>   

Glad to hear it! :)

> I meant that "/dev must be mounted for read-write mode"
>   

Again, why?
