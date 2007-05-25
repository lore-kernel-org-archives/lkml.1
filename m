Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXEYLW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXEYLW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbXEYLWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:22:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:48565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbXEYLWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:22:21 -0400
To: William Cohen <wcohen@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_DEBUG_RODATA prevents kprobes from working on 2.6.22-rc2
References: <46545EA5.3020201@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 May 2007 14:19:12 +0200
In-Reply-To: <46545EA5.3020201@redhat.com>
Message-ID: <p733b1lcczj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Cohen <wcohen@redhat.com> writes:
> 
> Shouldn't mark_rodata_ro be less agressive when CONFIG_KPROBES is
> enabled? Or should kprobes temporarily change the page to be
> writeable, set the break point, and then return the page to read only?

The later.

-Andi
