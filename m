Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYE0VuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYE0VuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbYE0VuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:50:04 -0400
Received: from sous-sol.org ([216.99.217.87]:45799 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbYE0VuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:50:03 -0400
Date: Tue, 27 May 2008 14:42:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: was "Re: capget() overflows buffers."
Message-ID: <20080527214206.GA30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523155718.GI30402@sequoia.sous-sol.org> <4837B4F5.4000100@kernel.org> <20080524080734.GV30402@sequoia.sous-sol.org> <483B611B.6040006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483B611B.6040006@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> How about the attached for a combined patch? Chris, the only change over
> last time is basically your suggested code change, with more comments
> and a less cautious warning...

Looks good, I'll queue it (I added

  Fixes issue reported in https://bugzilla.redhat.com/show_bug.cgi?id=447518.
  Thanks to Bojan Smojver for the report.

to the commit message).

thanks,
-chris
