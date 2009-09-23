Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbZIWPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbZIWPru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZIWPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:47:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZIWPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:47:49 -0400
Message-ID: <4ABA42D4.9070308@zytor.com>
Date: Wed, 23 Sep 2009 08:46:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tony Vroon <tony@linx.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>	 <4AB9B7B7.30200@kernel.org> <1253697550.3434.1.camel@localhost> <4AB9E925.8010502@kernel.org>
In-Reply-To: <4AB9E925.8010502@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tony Vroon wrote:
>> On Wed, 2009-09-23 at 14:52 +0900, Tejun Heo wrote:
>>> Can you please do l on the above rip - ffffffff81598250?
>> I was unable to:
>> (gdb) l *ffffffff81598250
>> No symbol "ffffffff81598250" in current context.
> 
> Ah... you should have done l *0xffffffff81598250.
> 

A better way to do this is:

addr2line -e vmlinux 0xffffffff81598250

No need to involve gdb.

	-hpa

