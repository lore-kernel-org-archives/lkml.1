Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0CBXzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:55:51 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:43988 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab0CBXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:55:48 -0500
Date: Tue, 2 Mar 2010 18:55:20 -0500 (EST)
From: Ari Entlich <atrigent@ccs.neu.edu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <12806278.317911267574120161.JavaMail.root@zimbra>
In-Reply-To: <14018832.317861267574035528.JavaMail.root@zimbra>
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.241.22.119]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Could you please remove this patch from your 2.6.34 tty pull request?
Andrew Morton questioned whether this should actually be used yet[1],
and I responded confirming his suspicions[2]. In addition, this patch
has not "been in the linux-next and -mm releases for a number of
weeks now", as you suggest in your pull request.

Thanks!

[1] http://marc.info/?l=linux-kernel&m=126687954823617
[2] http://marc.info/?l=linux-kernel&m=126689506608539

----- "Greg Kroah-Hartman" <gregkh@suse.de> wrote:
> From: Ari Entlich <atrigent@ccs.neu.edu>
> 
> This new VT mode (VT_PROCESS_AUTO) does everything that VT_PROCESS does
> except that it doesn't wait for a VT_RELDISP ioctl before switching
> away from a VT with that mode.
> 
> [etc, etc...]
