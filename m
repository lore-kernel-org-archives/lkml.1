Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbZJLQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbZJLQVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbZJLQU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:20:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53909 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbZJLQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:20:58 -0400
Date: Mon, 12 Oct 2009 17:20:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, soni.trilok@gmail.com
Subject: Re: [PATCH] Haptic class support (v2)
Message-ID: <20091012162020.GF22233@sirena.org.uk>
References: <20091006074533.GA28889@july> <ac3eb2510910120842m3129b76fyaa11b509e7f97038@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510910120842m3129b76fyaa11b509e7f97038@mail.gmail.com>
X-Cookie: Don't hit the keys so hard, it hurts.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:42:08PM +0200, Kay Sievers wrote:
> On Tue, Oct 6, 2009 at 09:45, Kyungmin Park <kmpark@infradead.org> wrote:

> > To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
> > You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
> > or
> > With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot

> Please never add any custom files to the top-level of a class
> directory. This place is reserved for devices, and not for custom
> files. It's a serious bug in the layout and API of sysfs that this
> allowed at all.

I'm assuming that ${name} is the device name in the above in which case
it should be fine from that point of view?
