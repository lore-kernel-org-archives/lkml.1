Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbYDQPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbYDQPYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbYDQPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:24:32 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:52327 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1758266AbYDQPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:24:32 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 18 Apr 2008 01:24:05 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linux-acpi@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: pnpacpi: reduce printk severity for "pnpacpi: exceeded the max	number of ..."
Message-ID: <20080417152405.GB14206@tull.net>
References: <20080417010122.148289106@sous-sol.org> <20080417010359.629397865@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417010359.629397865@sous-sol.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 06:02:20PM -0700, Chris Wright wrote:
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> +		printk(KERN_WARNING "pnpacpi: exceeded the max number of IRQ "
>  				"resources: %d \n", PNP_MAX_IRQ);

This is a good time to delete that whitespace before the newline
in this hunk plus the two following. Unless you're going to go to
dynamic memory allocation for these arrays in a month and wipe
out all this code.

Nick.
