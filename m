Return-Path: <linux-kernel-owner+w=401wt.eu-S965403AbXAYWMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403AbXAYWMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXAYWMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:12:15 -0500
Received: from agmk.net ([87.236.194.20]:4289 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965403AbXAYWMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:12:14 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
Date: Thu, 25 Jan 2007 23:11:46 +0100
User-Agent: KMail/1.9.6
Cc: Len Brown <lenb@kernel.org>, Adrian Bunk <bunk@stusta.de>,
       linux-acpi@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <200701242346.44673.pluto@agmk.net> <20070124225238.GT17836@stusta.de> <200701242350.45276.lenb@kernel.org>
In-Reply-To: <200701242350.45276.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200701252311.46858.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 of January 2007 05:50:45 Len Brown wrote:
> On Wednesday 24 January 2007 17:52, Adrian Bunk wrote:
> > On Wed, Jan 24, 2007 at 11:46:44PM +0100, Paweł Sikora wrote:
> > > for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
> > > http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
> > > disabling the "amd-k8 cool'n'quiet" option in bios helps.
> > > moreover, it works fine for 2.6.17.13, so it looks like
> > > a recent regression. i can provide more details if you need.
> >
> > thanks for your report.
> >
> > Can you narrow down a bit when it started?
> > Is 2.6.19 OK?
> > Is 2.6.18 OK?
>
> Is the stack trace always the same?  It doesn't make much sense to me.

with debug options enabled oops looks better:
http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-oops-01.jpg
