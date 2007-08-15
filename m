Return-Path: <linux-kernel-owner+w=401wt.eu-S935794AbXHOVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935794AbXHOVEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXHOVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:03:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:56025 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437AbXHOVDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:03:52 -0400
Date: Wed, 15 Aug 2007 23:05:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Kees Cook <kees@outflux.net>
Subject: Re: [PATCH] [RESEND] PIE executable randomization
In-Reply-To: <46C33A67.1020102@redhat.com>
Message-ID: <Pine.LNX.4.64.0708152304260.29843@jikos.suse.cz>
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz>
 <20070814200647.GN2063@devserv.devel.redhat.com> <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz>
 <46C33A67.1020102@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Chuck Ebbert wrote:

> But your patch is enabling randomization for x86_64, because CONFIG_X86 
> includes both 32 and 64 bit archs.

Hi Chuck,

yes, and this is addressed by the second patch I have sent yesterday, 
which enables flexmmap for x86_64.

-- 
Jiri Kosina
SUSE Labs
