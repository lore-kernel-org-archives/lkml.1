Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYGPIIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYGPIIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYGPIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:07:45 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47793 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYGPIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:07:44 -0400
Message-ID: <487DACBB.6000909@keyaccess.nl>
Date: Wed, 16 Jul 2008 10:09:31 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Hubbard <david.c.hubbard@gmail.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, linuxppc-dev@ozlabs.org,
       Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>, lm-sensors@lm-sensors.org
Subject: Re: [RFC] (almost) booting allyesconfig -- please don't poke super-io
 without request_region
References: <for-27-patch1-0@bga.com>	<4879A144.8060203@hhs.nl>	<4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>	<487A7211.7030309@hhs.nl>	<4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>	<20080714095914.0644ac5d@hyperion.delvare>	<88f5162604470179b3c6ebfe729a46f5@bga.com>	<487B8D2C.1090208@hhs.nl>	<4dfa50520807141055l532caaaai700255936600e5ae@mail.gmail.com>	<20080715103613.4fbbf01f@hyperion.delvare>	<4dfa50520807150831i519a3a43n635ab7e58d35ba5e@mail.gmail.com> <20080716094602.4379e0ff@hyperion.delvare>
In-Reply-To: <20080716094602.4379e0ff@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-07-08 09:46, Jean Delvare wrote:

> As a conclusion, there is no clear relationship between the presence
> of an ISA or LPC bridge and the presence of a Super-I/O chip. All we
> can say is that apparently all PC systems have an ISA bridge. So
> indeed we can probably make the probes conditional upon the presence
> of an "ISA bridge" PCI device. That's very easy to test. In practice
> it might be equivalent to making the driver x86-only.

And foregoing non (pre-) PCI. Admittedly, that might not be much of an 
issue and I don't know if "Super-I/O" is maybe even defined such as to 
make it a NON issue but I do for example remember my old 386 chipset 
providing for extended serial rates which I thought was way cool back 
then. If that's Super-I/O (or something that should/could be covered by 
the infrastructure at least) then PCI wouldn't be helpful.

Rene.


