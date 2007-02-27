Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXB0H6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXB0H6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 02:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXB0H6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 02:58:55 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33298 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXB0H6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 02:58:54 -0500
Date: Tue, 27 Feb 2007 08:59:37 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Dave Jones <davej@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq build regression added today
Message-ID: <20070227075937.GA27409@aepfle.de>
References: <20070226.144134.95506510.davem@davemloft.net> <20070226224648.GB24976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070226224648.GB24976@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, Dave Jones wrote:

> On Mon, Feb 26, 2007 at 02:41:34PM -0800, David Miller wrote:
>  > 
>  > Dave, please test your const'ification changes, else you'll
>  > leave some of us const'ipated :-)
>  > 
>  > drivers/cpufreq/cpufreq.c: In function 'cpufreq_register_driver'
>  > drivers/cpufreq/cpufreq.c:1767: error: assignment of read-only location
> 
> Damn you're fast.
> That stuff wasn't near ready to go to mainline, I've asked Linus
> to revert.  Mea Culpa.

e5524f355a0d272ba5233537a896a668db1f3008 is partly broken as well.

-struct agp_bridge_driver uninorth_agp_driver = {
+struct const agp_bridge_driver uninorth_agp_driver = {

