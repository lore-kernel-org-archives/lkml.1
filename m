Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXDNPgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXDNPgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXDNPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:36:33 -0400
Received: from colargol.tihlde.org ([158.38.48.10]:54416 "EHLO
	colargol.tihlde.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbXDNPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:36:32 -0400
X-Greylist: delayed 2245 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 11:36:32 EDT
Message-ID: <4620EC23.4010404@mrfjo.org>
Date: Sat, 14 Apr 2007 16:58:43 +0200
From: =?ISO-8859-1?Q?Espen_Fjellv=E6r_Olsen?= <espen@oxygen.tihlde.org>
Reply-To: "Drift@tihlde" <drift@tihlde.org>
User-Agent: Thunderbird 2.0.0.0pre (Windows/20070408)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Drift@tihlde" <drift@tihlde.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 129.241.123.213
X-SA-Exim-Mail-From: espen@mrfjo.org
Subject: Machine Check Exception on Opteron 265
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on oxygen.tihlde.org)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
Today our Opteron 265, 2x2, paniced after many months uptime, giving
only this error message:

HARDWARE ERROR
CPU 2: Machine Check Exception:            4 Bank 4: b60a200100000813
TSC 6bb9fd0142921a ADDR a891e9b8
This is not a software problem!

mcelog --ascii gives this on the above error:

HARDWARE ERROR
CPU 2 4 northbridge TSC 6bb9fd0142921a
  Northbridge ECC error
  ECC syndrome = 14
       bit32 = err cpu0
       bit45 = uncorrected ecc error
       bit57 = processor context corrupt
       bit61 = error uncorrected
  bus error 'local node origin, request didn't time out
      generic read mem transaction
      memory access, level generic'
STATUS b60a200100000813 MCGSTATUS 4
This is not a software problem!


As far as we know there wasnt any unuasal activity on the server at the
time.
We updated glibc yesterday, but that shouldnt really cause such a problem.
So now we wonder if this might be an MCE bug, or really a HW problem,
and if it is one of the CPUs, or the RAM thats faulty.
We are running 2.6.18.

--
Mvh
Espen Fjellvær Olsen
Drift@Tihlde
espen@mrfjo.org
