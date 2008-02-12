Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbYBLRwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbYBLRwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYBLRw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:52:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:60099 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760318AbYBLRw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:52:27 -0500
Date: Tue, 12 Feb 2008 09:50:15 -0800
From: Greg KH <gregkh@suse.de>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Matthew Keenan <matt@opcode-solutions.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.18
Message-ID: <20080212175015.GA2001@suse.de>
References: <20080211074313.GA23195@kroah.com> <20080211074346.GB23195@kroah.com> <1202729485.24584.5.camel@bazbox.opcode-solutions.com> <20080211154512.GA26178@suse.de> <878x1q6p6t.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878x1q6p6t.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 06:48:42PM +0100, Florian Weimer wrote:
> * Greg KH:
> 
> > the logic is a little different in 2.6.22 and earlier in regards to this
> > area of code.  This way we are safer.
> 
> Your patch doesn't include the CVE-2006-0010 hunk.  Is this because
> get_user() implies an access_ok() check (while __copy_from_user()
> obviously does not)?

Yes, that is exactly why.  CVE-2006-0010 and -0009 are not applicable to
kernels prior to 2.6.23.

thanks,

greg k-h
