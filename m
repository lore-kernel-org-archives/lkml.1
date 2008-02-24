Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYBXAv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYBXAv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYBXAvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:51:51 -0500
Received: from testure.choralone.org ([194.9.77.134]:35050 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYBXAvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:51:50 -0500
Date: Sat, 23 Feb 2008 19:51:39 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jaroslav Kysela <perex@perex.cz>,
       Jason Gaston <jason.d.gaston@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [BUG] snd-hda-intel
Message-ID: <20080224005139.GA31275@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Takashi Iwai <tiwai@suse.de>, Peter Zijlstra <peterz@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Jason Gaston <jason.d.gaston@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Arjan van de Ven <arjan@fenrus.demon.nl>
References: <1202912714.6811.3.camel@twins> <s5hy79prkqk.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy79prkqk.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:31:31PM +0100, Takashi Iwai wrote:
 > At Wed, 13 Feb 2008 15:25:14 +0100,
 > Peter Zijlstra wrote:
 > > 
 > > lspci -vvv:
 > > 
 > > 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
 > 
 > Is this a regression, i.e. did you get similar Oops with previous
 > kernels?

This looks like ..  http://www.kerneloops.org/guilty.php?guilty=azx_pcm_prepare&version=2.6.25-rc2&start=1638912&end=1639167&class=oops
kerneloops.org claims to have 2 oopses from 2.6.24 there too, but when clicked,
they show nothing. Arjan ?

	Dave
-- 
http://www.codemonkey.org.uk
