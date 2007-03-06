Return-Path: <linux-kernel-owner+w=401wt.eu-S966013AbXCFSsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013AbXCFSsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966008AbXCFSsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:48:15 -0500
Received: from gw.goop.org ([64.81.55.164]:56070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966013AbXCFSsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:48:14 -0500
Message-ID: <45EDB76A.4050604@goop.org>
Date: Tue, 06 Mar 2007 10:48:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <20070306073511.GA3938@elte.hu> <45ED1B64.9040104@vmware.com>
In-Reply-To: <45ED1B64.9040104@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Yes, I don't have a problem with your patch, I just wish I had been
> cc'd on it.  Fixing this is rather tricky, but I believe no strange
> build magic is required, it can be done in kernel init code.  Still
> building my SUSE 9.0 guest to test.  SUSE 9.0 is one of those that
> requires COMPAT_VDSO, yes?

Where do we stand on VDSO reloc?  Are you turning this into a proper
patch, or shall I have a look at it?

    J
