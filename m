Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXEWS2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXEWS2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEWS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:28:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34181 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbXEWS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:28:03 -0400
Message-ID: <4654867B.1060509@us.ibm.com>
Date: Wed, 23 May 2007 11:22:51 -0700
From: Ian Romanick <idr@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org> <200705230723.42400.mgd@technosis.de> <1179907115.7699.271.camel@frg-rhel40-em64t-04>
In-Reply-To: <1179907115.7699.271.camel@frg-rhel40-em64t-04>
X-Enigmail-Version: 0.94.0.0
OpenPGP: id=AC84030F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Xavier Bestel wrote:
> On Wed, 2007-05-23 at 07:23 +0200, Michael Gerdau wrote:
>> For me the huge difference you have for sd to the others increases the
>> likelyhood the glxgears benchmark does not measure scheduling of graphic
>> but something else.
> 
> I think some people forget that X11 has its own scheduler for graphics
> operations.

And in the direct-rendering case, this scheduler is not used for OpenGL.
 The client-side driver submits rendering commands directly to its
kernel module.  It is possible that some kernel modules perform some
sort of scheduling, but none of the open-source drivers implement such a
thing.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGVIZ7X1gOwKyEAw8RAottAJ9oQtnKVZ+xwrZXxyndanwkswp3IACeNY2v
JJeDU3cgBtn1dBOr3erl3Ww=
=YnG7
-----END PGP SIGNATURE-----
