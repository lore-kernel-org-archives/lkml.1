Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXBJWfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXBJWfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBJWfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:35:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXBJWfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:35:36 -0500
Date: Sat, 10 Feb 2007 22:35:13 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mbroz@redhat.com,
       dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21 -- md-dm-reduce-stack-usage-with-stacked-block-devices.patch
Message-ID: <20070210223513.GA7201@agk.surrey.redhat.com>
Mail-Followup-To: Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>, mbroz@redhat.com,
	dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
	linux-kernel@vger.kernel.org
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 10:58:58AM +0100, Heiko Carstens wrote:
> Alasdair, is dm already fixed or is there any chance that it will
> ever get fixed?

I still expect us to get this changed within the next few months.  We've
dealt with the changes necessary to the crypt target for this.  The final
problem remaining is the core dm bio splitting code, and there's a related
locking problem in that code to tackle at the same time.

Alasdair
-- 
agk@redhat.com
