Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbZIWJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbZIWJX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZIWJX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:23:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:58585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZIWJX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:23:56 -0400
Message-ID: <4AB9E925.8010502@kernel.org>
Date: Wed, 23 Sep 2009 18:23:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>	 <4AB9B7B7.30200@kernel.org> <1253697550.3434.1.camel@localhost>
In-Reply-To: <1253697550.3434.1.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 09:23:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> On Wed, 2009-09-23 at 14:52 +0900, Tejun Heo wrote:
>> Can you please do l on the above rip - ffffffff81598250?
> 
> I was unable to:
> (gdb) l *ffffffff81598250
> No symbol "ffffffff81598250" in current context.

Ah... you should have done l *0xffffffff81598250.

> Here is my vmlinux, LZMA-packed (~15MB download):
> http://www.vroon.org/vmlinux.lzma
> 
> Hopefully this will allow you to find out the information requested.

But having the kernel image is much better.  Thanks.

-- 
tejun
