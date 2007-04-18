Return-Path: <linux-kernel-owner+w=401wt.eu-S2992696AbXDRVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992696AbXDRVIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXDRVIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:08:11 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:54516 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964935AbXDRVIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:08:10 -0400
Message-ID: <462688AB.4060707@gmail.com>
Date: Wed, 18 Apr 2007 23:07:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: johann deneux <johann.deneux@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@insightbb.com>, stenyak@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
References: <210731960111436322@karneval.cz> <38b3b7c0704181300p78df84f3h8fd4e74428d4e4d8@mail.gmail.com>
In-Reply-To: <38b3b7c0704181300p78df84f3h8fd4e74428d4e4d8@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 18 Apr 2007 23:07:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johann deneux napsal(a):
> Jiri,
> 
> Which solution did you chose to implement? From what I remember, we
> last discussed Dmitry's idea of specifying an axis for an effect, then
> combine several effects to achieve complex effects.

I think you mean motor instead of axis, because I don't push real axes to
the devices, but motor's torques...

> The implementation would specify the axis using the upper bits of the
> effect type.

Ok, if this is preferred, I'll post it with the const of having more context
switches for a single effect.

This was just a realization of the idea how I though it with the
quick'n'dirty FF_RAW.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
