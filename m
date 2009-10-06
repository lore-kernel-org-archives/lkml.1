Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZJFHbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZJFHbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZJFHbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:31:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZJFHbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:31:20 -0400
Message-ID: <4ACAF21B.2080105@kernel.org>
Date: Tue, 06 Oct 2009 16:30:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org> <4AB09562.3010501@klingt.org> <4AB0D34A.2010502@kernel.org> <4ABC44FE.5050904@kernel.org> <4ABC7543.90407@klingt.org> <4ABC7714.2030709@kernel.org> <4ABCADE2.1020300@klingt.org> <4ABCC3DB.1000202@kernel.org> <4AC58D9C.6010306@kernel.org> <4AC5AC0D.9020901@klingt.org> <4AC5C0DF.50706@kernel.org> <4AC9C373.80603@klingt.org>
In-Reply-To: <4AC9C373.80603@klingt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 07:30:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tim Blechmann wrote:
>>> since i have this kernel running, i didn't see any of these messages,
>>> still, my hds always showed up ...
>>> not sure, if this is related to your patch or if the buggy behavior,
>>> just didn't occur ...
>> Can you please reboot several times and see whether libata probing
>> messages show anything interesting?
> 
> unfortunately, i didn't see any libata related messages, which could be 
> of interest ... 
> the relevant part looks mostly like this:
> 
> not sure, what this means, though ...

It means the original condition didn't trigger most likely due to
timing differences. :-( I'll push the patch upstream.

Thanks.

-- 
tejun
