Return-Path: <linux-kernel-owner+w=401wt.eu-S1764461AbYBLSOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764461AbYBLSOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbYBLSNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:13:48 -0500
Received: from mail.enyo.de ([212.9.189.167]:4965 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762611AbYBLSNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:13:47 -0500
X-Greylist: delayed 1492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 13:13:47 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Keenan <matt@opcode-solutions.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.18
References: <20080211074313.GA23195@kroah.com>
	<20080211074346.GB23195@kroah.com>
	<1202729485.24584.5.camel@bazbox.opcode-solutions.com>
	<20080211154512.GA26178@suse.de>
Date: Tue, 12 Feb 2008 18:48:42 +0100
In-Reply-To: <20080211154512.GA26178@suse.de> (Greg KH's message of "Mon, 11
	Feb 2008 07:45:12 -0800")
Message-ID: <878x1q6p6t.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH:

> the logic is a little different in 2.6.22 and earlier in regards to this
> area of code.  This way we are safer.

Your patch doesn't include the CVE-2006-0010 hunk.  Is this because
get_user() implies an access_ok() check (while __copy_from_user()
obviously does not)?
