Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZFYWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZFYWFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZFYWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:04:53 -0400
Received: from solo.fdn.fr ([80.67.169.19]:57270 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbZFYWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:04:52 -0400
Date: Fri, 26 Jun 2009 00:04:52 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090625220452.GF5540@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just as a reminder, Speakup is an in-kernel screen reader that uses
hardware speech synthesis to say what gets printed on the Linux console.

In the process of cleaning it, we are moving its configuration stuff
into proper places.  I believe there are two things:

- per- harware speech synthesizer parameters (e.g. speed, pitch, etc.)
- screen reading parameters (e.g. characters pronunciation, key_echo,
  current synthesizer being used etc.)

Speech synthesizers should probably have their own device class, how
should it be called? "synth"? "speech"?

Synthesizers are usually plugged on serial ports, but there is no bus
abstraction for that, so I believe we can put them in the virtual bus.

Then there are the screen reading parameters. I'd tend to think that
like there are /sys/{block,firmware,fs,power}, there could be a
/sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
could then be in /sys/a11y/speakup?

Samuel
