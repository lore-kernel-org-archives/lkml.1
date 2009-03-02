Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZCBQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZCBQ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZCBQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:26:37 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49087 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZCBQ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:26:36 -0500
Date: Mon, 2 Mar 2009 16:26:21 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
       davej@redhat.com
Subject: Re: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Message-ID: <20090302162621.GB25965@silver.sucs.org>
References: <200903021704.59663.denys@visp.net.lb> <20090302160658.GA32708@srcf.ucam.org> <200903021815.56191.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903021815.56191.denys@visp.net.lb>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:15:56PM +0200, Denys Fedoryschenko wrote:
> On Monday 02 March 2009 18:06:59 Matthew Garrett wrote:
> > On Mon, Mar 02, 2009 at 05:04:59PM +0200, Denys Fedoryschenko wrote:
> > > On 2.6.29-rc6 (git5 tested also) also shown in dmesg as available, but i
> > > can't change anything.
> >
> > That's deliberate. p4-clockmod is for thermal management, not clock
> > control (since it doesn't actually do any of that)
> I know very well it is just throttling, and not real CPU power management.
> At the end it does job.
> 
> In my case i used it for testing on "virtual" 113 Mhz video encoding to find 
> out bottleneck on ffmpeg and to compare performance with Blackfin.

If it's just throttling you want can't you do that via
/proc/acpi/processor/CPU<N>/throttling ...

-- 
Sitsofe | http://sucs.org/~sits/
