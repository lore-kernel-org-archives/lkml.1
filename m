Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXIDHXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXIDHXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXIDHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:23:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:33920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXIDHXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:23:04 -0400
From: Andi Kleen <ak@suse.de>
To: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] Restore call_usermodehelper_pipe() behaviour
Date: Tue, 4 Sep 2007 08:17:42 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, jeremy@xensource.com, rusty@rustcorp.com.au,
       dhowells@redhat.com, B.Steinbrink@gmx.de, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
References: <a96a9b883c735b73866cf39997bdc8d5f9f1c451.1188887696.git.michael@ellerman.id.au>
In-Reply-To: <a96a9b883c735b73866cf39997bdc8d5f9f1c451.1188887696.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709040817.43063.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The fix is to change the 1 to UMH_WAIT_EXEC (aka 0), indicating that we
> want to wait for the kernel thread to be started, but not for the helper to
> finish.

Looks good. Clear 2.6.23 candidate IMHO

-Andi
