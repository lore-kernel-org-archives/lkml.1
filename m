Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYBXPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYBXPlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYBXPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:40:59 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50252 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYBXPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:40:58 -0500
Message-ID: <47C19001.7010609@student.ltu.se>
Date: Sun, 24 Feb 2008 16:40:49 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se> <m3ejb2bdxx.fsf@maximus.localdomain>
In-Reply-To: <m3ejb2bdxx.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>
>   
>> Why hinder a developer who prefer
>> 2, 4, 6 or any other != 8 width?
>>     
>
> I guess we could use tabs only at the line start, for indentation
> only. Rather hard to implement, most text editors can't do that yet.
>   
You mean for split lines? Hopefully there won't be that many, so there 
is just to delete the tabs it added and replace it with spaces.
>   
>> By only using tabs as indents, and
>> changing the CodeStyle to be something like "maximum 80
>> characters-wide lines, with a tab-setting of 8 spaces",
>>     
>
> This changes nothing.
>   
Exactly! But then we can remove the "we use 8 wide tabs in the kernel" 
in CodeStyle.
>   
>> that is
>> possible + easier to write code-checkers [2].
>>     
>
> I doubt it.
>   
Easier to write code-checkers? OK, maybe not. Just that I got hit by 
this problem at a time when I wrote a simple checker (don't remember its 
purpose).
>   
>> Or are we really that concerned about the disk-space? ;)
>>     
>
> Unpacked sources will be much bigger with not tabs, sure.
>   
Without no tabs at all, you mean? Don't want to think about that 
scenario, but with this suggestion, I would estimate maybe 0,5 - 1% bigger.

Thanks for your input

