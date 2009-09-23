Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZIWX0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZIWX0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZIWX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:26:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:37898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZIWX0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:26:07 -0400
Message-ID: <4ABAAE81.3010104@kernel.org>
Date: Thu, 24 Sep 2009 08:25:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tony Vroon <tony@linx.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>	 <4AB9B7B7.30200@kernel.org> <1253697550.3434.1.camel@localhost> <4AB9E925.8010502@kernel.org> <4ABA42D4.9070308@zytor.com>
In-Reply-To: <4ABA42D4.9070308@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 23:25:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Tejun Heo wrote:
>> Tony Vroon wrote:
>>> On Wed, 2009-09-23 at 14:52 +0900, Tejun Heo wrote:
>>>> Can you please do l on the above rip - ffffffff81598250?
>>> I was unable to:
>>> (gdb) l *ffffffff81598250
>>> No symbol "ffffffff81598250" in current context.
>>
>> Ah... you should have done l *0xffffffff81598250.
>>
> 
> A better way to do this is:
> 
> addr2line -e vmlinux 0xffffffff81598250
> 
> No need to involve gdb.

Neat.  I usually keep gdb open as a calculator w/ C syntax, so I've
never looked for other stuff but this is much better for bug
reporters.  Thanks.

-- 
tejun
