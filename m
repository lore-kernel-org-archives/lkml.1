Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXJRFYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXJRFYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXJRFX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:23:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36468 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbXJRFX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:23:58 -0400
Date: Wed, 17 Oct 2007 22:21:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kaigai@kaigai.gr.jp,
       casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071018052111.GQ3906@sequoia.sous-sol.org>
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil> <20071016214159.GB13294@sergelap.austin.ibm.com> <20071017180002.33fe4986.akpm@linux-foundation.org> <20071018025920.GA5067@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018025920.GA5067@vino.hallyn.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serge@hallyn.com) wrote:
> I guess now that I've written this out, it seems pretty clear
> that capget64() and capget64() are the way to go.  Any objections?

How is capget64() different from capget() that supports 2 different
header->versions (I thought that was the whole point of the versioned,
rather opaque interface)?  I don't object to a new syscall, but I don't
see why it's required to avoid breaking libcap.

thanks,
-chris
