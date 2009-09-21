Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZIUHuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZIUHuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZIUHuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:50:05 -0400
Received: from poutre.nerim.net ([62.4.16.124]:54005 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZIUHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:50:04 -0400
Date: Mon, 21 Sep 2009 09:50:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp support for Core i5 CPU
Message-ID: <20090921095005.1ec418b7@hyperion.delvare>
In-Reply-To: <51f3faa70909201553y75cb9f8q8ab34e9659fe479b@mail.gmail.com>
References: <4AB5DE1F.1020004@gmail.com>
	<20090920211620.1c18d7fb@hyperion.delvare>
	<51f3faa70909201553y75cb9f8q8ab34e9659fe479b@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 16:53:53 -0600, Robert Hancock wrote:
> On Sun, Sep 20, 2009 at 1:16 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > Supporting the digital thermal sensor is one thing, but it is totally
> > insufficient. If you look at the coretemp driver, you'll see we need to
> > figure out a number of calibration values which are model-dependent. So
> > we will need to check this part before adding support for new CPU
> > models anyway.
> 
> Well, I see there is the TCC activation temperature which the reading
> is relative to, which is detected on the mobile CPUs via an MSR read,
> so it would only be a problem if they changed this temperature on
> other CPUs..

They actually did change it on almost every CPU model so far. I fail to
see why that would suddenly change (even though I'd really love it.)

> It might make sense to warn "unknown CPU model, temperature reading
> may be suspect" or something, but I should think it should still load
> as the temperature reading is likely still correct.

Our experience is the exact opposite. The temperature reading is likely
not correct. And we prefer not telling the user anything than to tell
him/her something incorrect. Most users won't notice warnings in their
kernel logs, all they see is a CPU temperature value in their desktop
tray area.

I hope Intel will finally take over the driver maintenance and deal
with their own mess. It has been a pain for us to maintain since day 2.

-- 
Jean Delvare
