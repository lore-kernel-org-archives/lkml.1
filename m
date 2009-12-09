Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZLIKIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZLIKIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbZLIKIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:08:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:55500 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbZLIKId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:08:33 -0500
Date: Wed, 9 Dec 2009 19:07:39 +0900
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gcosta@redhat.com,
       mingo@elte.hu
Subject: Re: [Patch] i386: remove 'usedac' kernel parameter
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091209062850.4245.11541.sendpatchset@localhost.localdomain>
References: <20091209062850.4245.11541.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091209190649I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 09 Dec 2009 19:07:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 01:25:48 -0500
Amerigo Wang <amwang@redhat.com> wrote:

> It is scheduled to be removed.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Glauber Costa <gcosta@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 591e944..8c895f6 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
>  
>  ---------------------------
>  
> -What:	usedac i386 kernel parameter
> -When:	2.6.27
> -Why:	replaced by allowdac and no dac combination
> -Who:	Glauber Costa <gcosta@redhat.com>
> -
> ----------------------------
> -

I'm not sure about the above description, I'm not against removing
this option though.

IIUC, the usedac option enables us to stop via_no_dac() setting
forbid_dac to 1. That is, someone who uses VIA bridges can use DAC
with this option even if some of VIA bridges seem to be broken about
DAC. I can't see how we can do the same thing with "allowdac" and
"nodac" combination.
