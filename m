Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXC0Rk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXC0Rk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXC0Rk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:40:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034AbXC0Rk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:40:58 -0400
To: Tom Horsley <tom.horsley@ccur.com>
Cc: linux-kernel@vger.kernel.org, bugsy <bugsy@ccur.com>
Subject: Re: TLS info and core files?
References: <20070327092041.40947947@tweety>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 20:39:38 +0200
In-Reply-To: <20070327092041.40947947@tweety>
Message-ID: <p738xdi4jkl.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Horsley <tom.horsley@ccur.com> writes:
> 
> Should core files have NOTE entries added for some sort of
> thread local storage info to be recorded? (Whatever the
> kernel happens to know that won't be accessible anymore
> after the process is gone, which would probably vary
> from architecture to architecture.)

I think that would be a good idea. Shouldn't be very hard 
to implement. Please send a patch.

We also miss some other information in core files 
I found useful in the past, like the CR3 and some other registers. 
The printks on x86-64 actually give more information 
than a core dump in some cases.

-Andi
