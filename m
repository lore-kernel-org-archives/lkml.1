Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJ2NLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJ2NLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYJ2NLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:11:03 -0400
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:32997 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYJ2NLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:11:01 -0400
From: Frans Pop <elendil@planet.nl>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Subject: Re: [patch] ACPI toshiba: only register rfkill if bt is enabled
Date: Wed, 29 Oct 2008 14:10:57 +0100
User-Agent: KMail/1.9.9
Cc: arvidjaar@mail.ru, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       philipl@overt.org
References: <20081029081934.GB26314@gambetta>
In-reply-To: <20081029081934.GB26314@gambetta>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291410.58310.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2008 13:10:58.0819 (UTC) FILETIME=[C8E05530:01C939C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> It looks like a part of the rfkill initialization was done whenever
> BT was on or not. The following patch checks for BT presence before
> registering the rfkill to the input layer. Does it solve the problem for
> you?
> 
> Regards,
> Frederik
> 
> Register toshiba RFKill Switch only if bluetooth is enabled
> 
> Part of the rfkill initialization was done whenever BT was on or not.
> The following patch checks for BT presence before registering the rfkill
> to the input layer. Some minor cleanups (> 80 char lines) were also
> added in the process.

I just saw the same issue on my Toshiba Satellite A40 with Atheros pcmcia 
card. The patch solves the kernel BUG for me when applied on top of 
current git.

Cheers,
FJP
