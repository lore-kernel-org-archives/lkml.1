Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbYGVHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYGVHrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYGVHrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:47:41 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:43595 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbYGVHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:47:40 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.22: USB getting stuck on SuperMicro PDSME+ boards
Date: Tue, 22 Jul 2008 09:48:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, nikola.ciprich@linuxbox.cz,
       linux-usb@vger.kernel.org
References: <20080722074357.GC21035@develbox.linuxbox.cz>
In-Reply-To: <20080722074357.GC21035@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807220948.28649.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 22 Juli 2008 09:43:57 schrieb Nikola Ciprich:
> I'm observing the problem even on machines without any USB devs attached.
> Unfortunately I wasn't able to reproduce the problem on my testing machines I have
> on my disposal here (yet, but I'm still trying), and it's not affecting all PDSME+ boards we have deployed.
> The problem appeared after upgrading machines to 2.6.24 kernels, we haven't observed it on 2.6.21 we used before.
> On affected machines, kernel doesn't emit any OOPS, or anything else which could help to track. It just stops working after some time.

Try to get a sysrq-t trace when it happens again. We need to know which
lock it hangs on. Also can you try 2.6.26? The bug may already be fixed.

	Regards
		Oliver

