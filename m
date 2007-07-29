Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXG2D6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXG2D6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXG2D6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:58:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:8675 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbXG2D6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Pma4l559kpNWFCWVAFAhZk2j6EkItPSvNqNF4NRP59lu4jFbQXeRP/yjlZKQjP3o4tAgC+FZ+/uyQDMyZp3Cjx8xLSVtNx9hDXuPW+Wo1Lr4vcG/zOhjYb3nYsqn/gLPDdV8IkPvaGCEzwAZZPwTafgBhuZyqVZIKnRfMcwkoqE=
Message-ID: <46AC0F6E.2000008@googlemail.com>
Date: Sun, 29 Jul 2007 05:54:22 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Danny ter Haar <dth@dth.net>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com> <20070729012324.GA29723@dth.net> <46ABFFE4.3060703@googlemail.com> <20070729033030.GA24636@dth.net>
In-Reply-To: <20070729033030.GA24636@dth.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Danny ter Haar wrote:
[ added  linux-acpi and Len to CC ]
> Quoting Gabriel C (nix.or.die@googlemail.com):
>> Maybe try to : 
>> disable BSG ( maybe some leftover bug )
>> boot acpi=off ( that got merged kind late )
> 
> My first git disected kernel wouldn't boot, but with
> acpi=off it would indeed boot!

Now while we think is ACPI this should be easy for you to bisect.

This commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=39804b20f62532fa05c2a8c3e2d1ae551fd0327b
merged ACPI so this one should be your first bad one.

Maybe Len has some idea and you don't need to bisect :)

> 
> As did the 2.6.23-rc1-git5 kernel...
> 
> I will bisect further to find out exactly what patch is
> playing up in my particular setup.
> 
> thanks for the tip! ;-)

You are welcome :)

> 
> Danny
> 

Gabriel
