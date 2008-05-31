Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYEaJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYEaJRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYEaJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:17:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:36537 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYEaJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vRl/adMrtkxM2mBYMOP6T3xp7PwksbpGkamQrjod3i7GD58knrg5D77DXVR7xIIqPONm9NxDeG79sfW2BHqQ1TMSQV2Bmagbjjg0QBN0LFpU2sVICZjkw6SQ5v0JLTeyk6F9XwDJKn0J37EEP2kA0IsL3tFMP1CkezyFMmtlBow=
Date: Sat, 31 May 2008 13:15:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default
Message-ID: <20080531091516.GA6949@cvg>
References: <20080528190047.GE6910@cvg> <g1qvlh$3dv$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g1qvlh$3dv$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sitsofe Wheeler - Sat, May 31, 2008 at 08:42:06AM +0100]
| Cyrill Gorcunov wrote:
| 
| > The commit
| > 
| > commit 4b82b277707a39b97271439c475f186f63ec4692
| > Author: Cyrill Gorcunov <gorcunov@gmail.com>
| > Date:   Sat May 24 19:36:35 2008 +0400
| > 
| > set nmi_watchdog to NMI_IO_APIC as by default. This causes hangs on some
| > machines with buggy watchdogs. Fix it - i.e. restore old behaviour.
| 
| Thanks for fixing this. Just for the record, the problem also seemed to
| depend on the ACPI Video option. Removing that also stopped the problem...
| However I can confirm that I don't have a boot hang with next-0530.
| 
| -- 
| Sitsofe | http://sucs.org/~sits/
|

ok, thanks for testing and additional info

		- Cyrill -
