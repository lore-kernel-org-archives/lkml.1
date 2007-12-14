Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXLNNQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXLNNQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbXLNNPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:15:37 -0500
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:50289
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207AbXLNNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:15:35 -0500
Subject: Re: [BUG] Kernel Bugs Weekly (maybe bi-weekly)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-dvb@linuxtv.org, linux-acpi@vger.kernel.org
In-Reply-To: <32209efe0712132057x247219e0m602f24d1e3a2c20b@mail.gmail.com>
References: <32209efe0712132057x247219e0m602f24d1e3a2c20b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 08:15:25 -0500
Message-Id: <1197638126.3154.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 20:57 -0800, Natalie Protasevich wrote:
> snd_hda_intel doesn't mute front speakers when headset is plugged in
> http://bugzilla.kernel.org/show_bug.cgi?id=9338
> Kernel: 2.6.23+
> Vaio VGN-FZ19VN

I'm not sure this one's a bug ... but it would depend on the chip
specifics.  The Intel HDA is designed to have separately controllable
line out and external features.  I like this and consider it to be a
nice feature.  However, it's not impossible that the Vaio is wired up
differently from my fujitsu, which also has a slightly different rev of
the controller:

00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 04)

However (modulo severe problems with pulseaudio) it works just fine for
me (separate sliders for line out and speakers) with 2.6.23.8 on a
Fujitsu 7120P LifeBook.

James


