Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZHQKhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZHQKhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZHQKht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:37:49 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:30965 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757351AbZHQKhs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:37:48 -0400
X-SpamScore: -23
X-BigFish: VPS-23(z21eWz98dN936eMzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOIO63-04-A4E-01
Date: Mon, 17 Aug 2009 12:37:15 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
CC: linux-kernel@vger.kernel.org, Doug Thompson <norsk5@yahoo.com>
Subject: Re: Backporting newer EDAC drivers to "stable" tree 2.6.27.x?
Message-ID: <20090817103715.GC3677@aftab>
References: <200908171106.00973.carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200908171106.00973.carsten.aulbert@aei.mpg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Aug 2009 10:37:15.0143 (UTC) FILETIME=[AFC21170:01CA1F26]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding Doug to CC. ]

On Mon, Aug 17, 2009 at 11:06:00AM +0200, Carsten Aulbert wrote:
> what is the recommended way to incorporate newer EDAC drivers from 2.6.30 or 
> later into the long term 2.6.27.x series? Are there ongoing efforts already we 
> could just re-use or does one "just" take the latest patchset and tries to 
> apply it cleanly (enough) to the latest long term kernel?

I've made an AMD64 EDAC backport for RHEL5.4 but since they're using a
heavily patched 2.6.18, this'll be of little or no use for you so you
might just as well slap the driver into .27 sources and fix it up.

There also might be the need to adjust some EDAC core
stuff for which Doug has some patches at the svn repo at
http://bluesmoke.sourceforge.net/ but you'll have to do a bit of
digging yourself :).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

