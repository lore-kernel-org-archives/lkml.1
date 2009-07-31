Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbZGaNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbZGaNui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZGaNuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:50:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55265 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750896AbZGaNuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:50:37 -0400
Date: Fri, 31 Jul 2009 14:50:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage
 regulator driver
Message-ID: <20090731135036.GA626@rakim.wolfsonmicro.main>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
 <20090731131005.GE17091@sirena.org.uk>
 <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
 <20090731133437.GF17091@sirena.org.uk>
 <b90c0690907310643n432c4504i1df5abaf8118e0b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b90c0690907310643n432c4504i1df5abaf8118e0b7@mail.gmail.com>
X-Cookie: Matrimony is the root of all evil.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 04:43:40PM +0300, Roger Quadros wrote:
> On Fri, Jul 31, 2009 at 4:34 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:

> > Feh, better print a warning for GPIO 0 for at least a kernel release.
> > Fortunately we've got no mainline users of fixed voltage regulators.

> I think most architectures start their GPIO numbering from 0.
> By 'a release', do you mean next Kernel release will be indexing GPIOs from 1?

No; I mean the driver should print a warning when using GPIO 0 as a way
of managing the transition.  Otherwise any existing users will find the
driver suddenly starts using a GPIO.
