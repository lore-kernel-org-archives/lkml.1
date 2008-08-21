Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYHUJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYHUJRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYHUJR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:17:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33065 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbYHUJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:17:28 -0400
X-Sasl-enc: FDcazBKvKsCOxIF/cxk00WXpjYKroQt3DouNIbOnJTcC 1219310246
Message-ID: <48AD32AA.1080600@ladisch.de>
Date: Thu, 21 Aug 2008 11:17:30 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ALSA pisses me off
References: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
In-Reply-To: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> I gather that somebody decided that USB audio should never be selected
> as the default.

Only when the order of sound cards has not been configured.

Put the following into /etc/modprobe.conf:

  options snd slots=snd-usb-audio,snd-virmidi

This should have been done by the sound card configuration utility of
your distribution.

> [...]
> The second is that, if a user adds USB audio, they probably want to
> use it! Plugging in a USB audio device should take over the audio,

It certainly should not this automatically in the kernel.  At best, this
is a decision to be made by userspace.


HTH
Clemens
