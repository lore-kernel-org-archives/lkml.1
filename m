Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZCBQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZCBQeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZCBQeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:34:00 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:52460 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZCBQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:33:59 -0500
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Date: Mon, 2 Mar 2009 18:33:46 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
       davej@redhat.com
References: <200903021704.59663.denys@visp.net.lb> <200903021815.56191.denys@visp.net.lb> <20090302162621.GB25965@silver.sucs.org>
In-Reply-To: <20090302162621.GB25965@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021833.46540.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 18:26:21 Sitsofe Wheeler wrote:
> On Mon, Mar 02, 2009 at 06:15:56PM +0200, Denys Fedoryschenko wrote:
> > On Monday 02 March 2009 18:06:59 Matthew Garrett wrote:
> > > On Mon, Mar 02, 2009 at 05:04:59PM +0200, Denys Fedoryschenko wrote:
> > > > On 2.6.29-rc6 (git5 tested also) also shown in dmesg as available,
> > > > but i can't change anything.
> > >
> > > That's deliberate. p4-clockmod is for thermal management, not clock
> > > control (since it doesn't actually do any of that)
> >
> > I know very well it is just throttling, and not real CPU power
> > management. At the end it does job.
> >
> > In my case i used it for testing on "virtual" 113 Mhz video encoding to
> > find out bottleneck on ffmpeg and to compare performance with Blackfin.
>
> If it's just throttling you want can't you do that via
> /proc/acpi/processor/CPU<N>/throttling ...

CPUFreq infrastructure much more powerful.
-d --min <FREQ>
    new minimum CPU frequency the governor may select. 
-u --max <FREQ>
    new maximum CPU frequency the governor may select. 
-g --governor <GOV>
    new cpufreq governor. 

This things you cannot do over inserting values over ACPI. Sure you can 
reinvent the wheel, but why?
