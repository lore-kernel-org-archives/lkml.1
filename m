Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYFCUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYFCUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbYFCUrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:47:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:41606 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759856AbYFCUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BJVXqZZBimDLPNx2wz8bb8emO2BAJUC+STJOR7FizBtwv2037VlXFZYvq58PgMJ8mWzJWIiXylupXYBPRWmKtQFpU1xeA5sFOxniZccG/gCGOlS0S2Cx64GRGV7sesPs87269rFYVD20Rptt3vlAZ9b2+BVAahiU9ToHHy0iJtU=
Message-ID: <4845AD90.4080909@gmail.com>
Date: Tue, 03 Jun 2008 22:46:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/1] Char: tty_io, fix closecount counting
References: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>	<48413B6E.3050202@gmail.com> <20080531144345.0a2f3c11@core>
In-Reply-To: <20080531144345.0a2f3c11@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2008 03:43 PM, Alan Cox wrote:
>> It is ever vcs1, which is /dev/console and it is the only treated separately 
>> (otherwise I think we would have more (and distinct) reports like this). 
>> When the console is HUPped? And what should happen with openers? The 
>> 2.6.22+suse happened when sulogin /dev/console was invoked. Any ideas how to 
>> track this down?
> 
> Its a complete and total mess is the obvious answer. In fact its far
> worse than it first looks and I don't believe it can be fixed without
> reworking the whole printk/console stuff.

Thanks a heap for the answer.
