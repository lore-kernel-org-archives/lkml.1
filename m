Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZCDBoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZCDBoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCDBn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:43:59 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:53547 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZCDBn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:43:58 -0500
Date: Wed, 4 Mar 2009 02:43:50 +0100
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
Message-ID: <20090304014350.GC5165@buzzloop.caiaq.de>
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de> <49AD8B0A.90901@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AD8B0A.90901@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 03, 2009 at 08:54:50PM +0100, Éric Piel wrote:
> Daniel Mack schreef:
> > This solves the dependency between lis3lv02d.[ch] and ACPI specific
> > methods. It introduces a ->bus_priv pointer to the device struct which
> > is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> > accordingly.
> > 
> > This also moves the read_8() and read_16() routines from hp_accel.c to
> > lis3lv02d.c as they are not specific to ACPI.
> Hello,
> I've tried the patch series on my laptop. This particular patch burst
> the driver... need some work :-) The values are not read correctly and
> the IRQ is not detected. See down in the code...

Ok, obvious fixes. I'll post a new set of the three topmost patches -
could you test them again, please?

Thanks and best regards,
Daniel

