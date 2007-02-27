Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbXB0Pue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbXB0Pue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 10:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXB0Pue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 10:50:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXB0Pue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 10:50:34 -0500
Date: Tue, 27 Feb 2007 10:50:24 -0500
From: Dave Jones <davej@redhat.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: cpufreq build regression added today
Message-ID: <20070227155024.GA24343@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Olaf Hering <olaf@aepfle.de>, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
References: <20070226.144134.95506510.davem@davemloft.net> <20070226224648.GB24976@redhat.com> <20070227075937.GA27409@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227075937.GA27409@aepfle.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 08:59:37AM +0100, Olaf Hering wrote:
 > On Mon, Feb 26, Dave Jones wrote:
 > 
 > > On Mon, Feb 26, 2007 at 02:41:34PM -0800, David Miller wrote:
 > >  > 
 > >  > Dave, please test your const'ification changes, else you'll
 > >  > leave some of us const'ipated :-)
 > >  > 
 > >  > drivers/cpufreq/cpufreq.c: In function 'cpufreq_register_driver'
 > >  > drivers/cpufreq/cpufreq.c:1767: error: assignment of read-only location
 > > 
 > > Damn you're fast.
 > > That stuff wasn't near ready to go to mainline, I've asked Linus
 > > to revert.  Mea Culpa.
 > 
 > e5524f355a0d272ba5233537a896a668db1f3008 is partly broken as well.

It's not my week.
Fixed in agpgart.git, and asked Linus to pull.

		Dave

-- 
http://www.codemonkey.org.uk
