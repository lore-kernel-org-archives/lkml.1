Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXKTKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXKTKf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXKTKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:35:17 -0500
Received: from sacred.ru ([62.205.161.221]:43121 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXKTKfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:35:16 -0500
Message-ID: <4742B84E.9010300@openvz.org>
Date: Tue, 20 Nov 2007 13:34:54 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 0/4] proc: Cleanup status files.
References: <20071117183109.GA2605@tv-sign.ru> <m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 20 Nov 2007 13:34:55 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> There is a long standing ugliness with /proc/<pid>/stat,
> /proc/<pid>/statm, and /proc/<pid>/status that they do not
> use the seqfile API.
> 
> In addition they are currently reporting pids in the pid namespace
> of the current task instead of the pid namespace with which proc
> was mounted which is confusing.

100% agree with that. Thanks for fixing this issue :)

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> This patch series first build the infrastructure to allow these
> problems to be fixed and then it converts the individual proc
> status files.
> 
> Eric
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

