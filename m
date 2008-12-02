Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYLBUPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYLBUPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLBUOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:14:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44332 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbYLBUOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:14:55 -0500
Date: Tue, 2 Dec 2008 21:14:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Message-ID: <20081202201442.GA1504@ucw.cz>
References: <1227454026.7262.59.camel@localhost> <20081123180409.GB7731@ucw.cz> <20081202161520.GA18252@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202161520.GA18252@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 16:15:21, Matthew Garrett wrote:
> On Sun, Nov 23, 2008 at 07:04:09PM +0100, Pavel Machek wrote:
> 
> > Is this really needed? Could we simply talk to the cpu directly,
> > without help of ACPI?
> 
> No. The ACPI write ends up talking to the embedded controller and some 
> io ports.

Oops... I always knew that eee-s are broken by design (reporting
battery percent as mWh, etc...) but I did not realize how bad it
is. (ACPI has perfectly standard cpu frequency scaling interface, even
if it is not used too often these days....)

Sorry for the noise.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
