Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYFHRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYFHRMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYFHRMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:12:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:56648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYFHRMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:12:08 -0400
Date: Sun, 8 Jun 2008 19:12:00 +0200
From: Bernhard Walle <bwalle@suse.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
       anderson@redhat.com
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080608191200.529d0619@kopernikus.site>
In-Reply-To: <20080608142606.GE2487@hacking>
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
	<20080608142606.GE2487@hacking>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* WANG Cong <xiyou.wangcong@gmail.com> [2008-06-08 22:26]:
>
> Since 'reserve_bootmem_generic' is changed from 'void' to 'int',
> we should check its return value for failure when possible, right?

That may make sense here, but that's unrelated to my change.

Just because the error *can* be caught by checking the return value
doesn't mean that it *must* be caught always. It was silently ignored
before in the efi_reserve_bootmem() function before, and so is it now.
No behaviour change.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
