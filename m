Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZKRTlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZKRTlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbZKRTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:40:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52872 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbZKRTk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:40:58 -0500
Date: Wed, 18 Nov 2009 19:40:53 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091118194053.GB12944@srcf.ucam.org>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com> <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> <1258474180.16176.62.camel@localhost.localdomain> <20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 08:30:07PM +0100, Kay Sievers wrote:

> Wouldn't it be good enough, if we add a file "idle_since" which
> contains the time of the actual disk idle time, and userspace can
> schedule a re-examination of that value at the actual end of the idle
> time it is looking for?

That would require either polling or waking up a userspace application 
on every disk access. Doing it in-kernel involves only a single timer 
wakeup for every active/idle transition.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
