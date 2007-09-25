Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXIYHvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXIYHvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXIYHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:50:55 -0400
Received: from science.horizon.com ([192.35.100.1]:19673 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751567AbXIYHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:50:54 -0400
Date: 25 Sep 2007 03:50:27 -0400
Message-ID: <20070925075027.5791.qmail@science.horizon.com>
From: linux@horizon.com
To: joe@perches.com, linux@horizon.com
Subject: Re: [RFC] New kernel-message logging API
Cc: linux-kernel@vger.kernel.org, vegard.nossum@horizon.com
In-Reply-To: <1190703254.3964.11.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Even the "kp_" prefix is actually pretty unnecessary.  It's "info"
>> and a human-readable string that make it recognizable as a log message.

> While I agree a prefix isn't necessary, info, warn, err
> are already frequently #define'd and used.
>
> kp_<level> isn't currently in use.
> 
> $ egrep -r -l --include=*.[ch] "^[[:space:]]*#[[:space:]]*define[[:space:]]+(info|err|warn)\b" * | wc -l
> 29

Sorry for being unclear.  I wasn't seriously recommending no prefix,
due to name collisions (exactly your point), but rather saying that no
prefix is necessary for human understanding.

Something to avoid the ambiguity is still useful.  I was just saying
that it can be pretty much anything withouyt confusing the casual
reader.

We're in violent agreement, I just didn't say it very well the first
time.
