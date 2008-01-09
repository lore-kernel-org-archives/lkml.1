Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYAIBbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYAIBbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYAIBbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:31:31 -0500
Received: from simmts12.bellnexxia.net ([206.47.199.141]:46738 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbYAIBbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:31:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAACuyg0ecIvL+/2dsb2JhbAAIqXE
Message-ID: <478423EC.5020000@gmail.com>
Date: Tue, 08 Jan 2008 21:31:24 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org> <200801090140.58864.arnd@arndb.de> <20080109004748.GI2117@one.firstfloor.org> <200801090219.46876.arnd@arndb.de>
In-Reply-To: <200801090219.46876.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 09 January 2008, Andi Kleen wrote:
>> I imagined it would check for 
>>
>> +struct file_operations ... = { 
>> +      ...
>> +       .ioctl = ...
>>
>> That wouldn't catch the case of someone adding only .ioctl to an 
>> already existing file_operations which is not visible in the patch context, 
>> but that should be hopefully rare. The more common case is adding
>> completely new operations
> 
> Right, this would work fine. We can probably even have a list of
> data structures that work like file_operations in this regard.
> 

file_operations & block_device_operations are the only two that I can find.

-- 
Kevin Winchester
