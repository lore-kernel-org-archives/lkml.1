Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXDUJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXDUJlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXDUJlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:41:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:42785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXDUJlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:41:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [RFC PATCH 0/3] Clean up x86 CPU feature setup
Date: Sat, 21 Apr 2007 11:41:16 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <4629438C.4070209@redhat.com>
In-Reply-To: <4629438C.4070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211141.16589.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 00:49:48 Chuck Ebbert wrote:
> x86 CPU feature flag setup has become impossible to debug.
> Every user just does set_bit()/clear_bit() or writes the
> entire set to change the flags, so there's no way to trace
> how they're being set.

Just use grep or printk? It is not *that* complicated. 

> This patchset creates an API and debug messages for tracking
> how the flags get set. It's not nearly done, but I want to
> know whether or not to continue.

I don't see any particular value. In theory we could add a "debug API"
for nearly everything, but in practice it is usually not needed.
Like here.

-Andi
