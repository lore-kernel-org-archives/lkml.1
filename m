Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYAWJKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYAWJKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYAWJKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:10:07 -0500
Received: from ns1.suse.de ([195.135.220.2]:55753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYAWJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:09:59 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 10:09:58 +0100
In-Reply-To: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
Message-ID: <p731w88nc0p.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> This patch adds a test module for the DEBUG_RODATA config
> option to make sure change_page_attr() did indeed make
> "const" data read only.

The only that this does that is not done pretty much equivalently
by pageattr-test.c (it just checks G instead of W) is testing the kernel 
text mapping on 64bit. On 32bit it is fully redundant I believe.

Testing the kernel mapping might be a good idea, but I would
suggest adding it to pageattr-test.c

Yes I'm sure these basic facts will not stop it from being 
applied anyways; just wanted to point it out for the benefit
of the list readers.

-Andi
