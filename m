Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbXBZWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbXBZWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933802AbXBZWqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:46:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbXBZWqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:46:52 -0500
Date: Mon, 26 Feb 2007 17:46:48 -0500
From: Dave Jones <davej@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq build regression added today
Message-ID: <20070226224648.GB24976@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20070226.144134.95506510.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226.144134.95506510.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 02:41:34PM -0800, David Miller wrote:
 > 
 > Dave, please test your const'ification changes, else you'll
 > leave some of us const'ipated :-)
 > 
 > drivers/cpufreq/cpufreq.c: In function 'cpufreq_register_driver'
 > drivers/cpufreq/cpufreq.c:1767: error: assignment of read-only location

Damn you're fast.
That stuff wasn't near ready to go to mainline, I've asked Linus
to revert.  Mea Culpa.

		Dave

-- 
http://www.codemonkey.org.uk
