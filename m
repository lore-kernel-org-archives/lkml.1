Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYFZAR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYFZAR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYFZARr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:17:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36061 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYFZARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:17:46 -0400
Date: Thu, 26 Jun 2008 01:17:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Zhang Rui <rui.zhang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2 userspace
Message-ID: <20080626001731.GA2618@srcf.ucam.org>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no> <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca> <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org> <1214279258.3001.76.camel@rzhang-dt.sh.intel.com> <20080624121455.GM7306@mars.solarsys.private> <48613130.7090004@keyaccess.nl> <alpine.LFD.1.10.0806251845160.3279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806251845160.3279@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 07:12:12PM -0400, Len Brown wrote:

> libsensors <= 2.10.6 users who upgrade their kernel to 2.6.26
> without distro support will get no bad surprises.
> 
> The down-side is simply that we are being less aggressive about
> exposing these temperature readings via hwmon.
> I'm not going to lose any sleep over that.

I'd agree. I don't think this is strictly necessary, but it makes life 
easier for users rolling their own kernel. Exposing these values via 
hwmon is nice, but not vital. They're not going to be able to make use 
of it without the new code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
