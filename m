Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZIYHyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZIYHyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZIYHx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:53:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:58189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZIYHx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:53:58 -0400
Message-ID: <4ABC7714.2030709@kernel.org>
Date: Fri, 25 Sep 2009 16:53:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org> <4AB04B39.7030907@kernel.org> <4AB079FC.6000906@kernel.org> <4AB09562.3010501@klingt.org> <4AB0D34A.2010502@kernel.org> <4ABC44FE.5050904@kernel.org> <4ABC7543.90407@klingt.org>
In-Reply-To: <4ABC7543.90407@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 25 Sep 2009 07:53:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
>>>>> Can you please try the attached patch and report the result?  The bug
>>>>> shouldn't happen now and for cases where it would have happened,
>>>>> libata will report "link online but device misclassified" and retry.
>>>> this patch cannot be applied onto stable-2.6.31/master ... e.g. the
>>>> first chunk is already in there ....
>>> Eh... the first chunk was for the current devel branch.  Here's a
>>> version without that one.
>> Ping.
> 
> i haven't run into any further issues with this patch ... so i somehow
> guess, it solved the problem ...

In your boot logs, do you ever see messages like "link online but
device misclassified, retrying"?

-- 
tejun
