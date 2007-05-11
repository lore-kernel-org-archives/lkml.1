Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXEKVWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXEKVWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbXEKVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:22:35 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:36875 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760600AbXEKVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:22:34 -0400
In-Reply-To: <20070511210850.GA382@uranus.ravnborg.org>
References: <20070511210850.GA382@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8210B049-55BD-409F-8A5E-EC5E1C365604@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [RFC PATCH] kbuild: silence section mismatch warnings
Date: Fri, 11 May 2007 16:22:28 -0500
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 11, 2007, at 4:08 PM, Sam Ravnborg wrote:

> ----- Forwarded message from Sam Ravnborg <sam@ravnborg.org> -----
>
> Forgot lkml in first mail...
>
> 	Sam
>
> Subject: [RFC PATCH] kbuild: silence section mismatch warnings
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 11 May 2007 23:03:46 +0200
> User-Agent: Mutt/1.4.2.1i
> To: Chris Wedgwood <cw@f00f.org>, Andrew Morton <akpm@osdl.org>,
> 	"David S. Miller" <davem@redhat.com>,
> 	Russell King <rmk@arm.linux.org.uk>,
> 	Satyam Sharma <satyam.sharma@gmail.com>
> Cc: sam@ravnborg.org
>
> Following patch allow us in specific places to silence section  
> mismatch warnings.
> There is a few legitime places that modpost does not yet recognize  
> where
> reference from .text to .init.text (likewise for data) are legitime.
> This allow us to spot the few places and annotate them so we do not
> get false warnings that in the end will let real warnings pass.
>
> The annotation is simple to grep for so revieing all uses in a few
> months time are trivial. It is assumed that a few places will
> use this to shut up the warning as replacement for the real fix.
> But these cases are esay to spot and to fix up.

Its unclear if you expect that some things will be tagged  
__init_refok/__initdata_refok forever or if we'll find some way to  
fix/change the code so the things tagged no longer need it.

> With this and the following two patches I have a section mismatch free
> build.
> The plan is that a section mismatch soon will graduate from a  
> warning to an error.
> This will hurt a few drives but then they have an incentive to fix  
> it up.
>
> Comments welcome.

- k
