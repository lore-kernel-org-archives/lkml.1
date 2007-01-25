Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXAYFAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXAYFAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXAYFAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:00:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:58725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbXAYFAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:00:46 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
Date: Wed, 24 Jan 2007 23:50:45 -0500
User-Agent: KMail/1.9.5
Cc: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       cpufreq@lists.linux.org.uk
References: <200701242346.44673.pluto@agmk.net> <20070124225238.GT17836@stusta.de>
In-Reply-To: <20070124225238.GT17836@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701242350.45276.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 17:52, Adrian Bunk wrote:
> On Wed, Jan 24, 2007 at 11:46:44PM +0100, Paweł Sikora wrote:

> > for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
> > http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
> > disabling the "amd-k8 cool'n'quiet" option in bios helps.
> > moreover, it works fine for 2.6.17.13, so it looks like
> > a recent regression. i can provide more details if you need.
> 
> thanks for your report.
> 
> Can you narrow down a bit when it started?
> Is 2.6.19 OK?
> Is 2.6.18 OK?

Is the stack trace always the same?  It doesn't make much sense to me.

if AMD cool & quiet is enabled in the BIOS, but CONFIG_CPU_FREQ=n
in the kernel, do you see the same problem?

thanks,
-Len
