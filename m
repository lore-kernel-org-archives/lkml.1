Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZCOFxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZCOFxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZCOFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:53:09 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3399 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZCOFxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:53:08 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Mar 2009 01:53:08 EDT
From: James Cloos <cloos@jhcloos.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
In-Reply-To: <1236683979-16178-1-git-send-email-daniel@caiaq.de> (Daniel
	Mack's message of "Tue, 10 Mar 2009 12:19:39 +0100")
References: <1236683979-16178-1-git-send-email-daniel@caiaq.de>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sun, 15 Mar 2009 01:41:58 -0400
Message-ID: <m34oxvfikh.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:29:090315:daniel@caiaq.de::T51iUP3qNajZaRwr:08N1Rv
X-Hashcash: 1:29:090315:linux-kernel@vger.kernel.org::fy3pa5Dv42sW4WRm:00000000000000000000000000000000K77aQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Daniel" == Daniel Mack <daniel@caiaq.de> writes:

Trivial comment on the docs:

Daniel> +mode:
Daniel> +	0: diode1's current (unsigned 16bit) (default)
Daniel> +	1: diode1's current (unsigned 16bit)
Daniel> +	2: difference between diodes (l1 - l2, signed 15bit)

That has diode1 twice.  Should it, instead, be:

+mode:
+	0: diode1's current (unsigned 16bit) (default)
+	1: diode2's current (unsigned 16bit)
+	2: difference between diodes (l1 - l2, signed 15bit)

?

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
