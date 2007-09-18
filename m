Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbXIRKuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbXIRKuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXIRKub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:50:31 -0400
Received: from mailgw11.fraunhofer.de ([153.96.1.23]:49702 "EHLO
	mailgw11.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbXIRKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:50:30 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 06:50:30 EDT
Date: Tue, 18 Sep 2007 12:39:42 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <46efaaee.iiX5iPDduWZOOvLg%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2007 10:43:21.0031 (UTC) FILETIME=[BB18E570:01C7F9E0]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> That's true now, but it wasn't always.  Until the last year or so, 
> cdrecord wouldn't work properly with USB CD drives having a 64-sector 
> limit unless the user added a particular command-line argument. 

This is a bug that is known since ~ 3 years and that has been fixed 
_very_ recently. It was still present in 2.6.21.7 a few weeks ago.

And BTW: the limit was not 64 sectors but ~13 sectors. 64 sectors would be at 
least 128 kB but the limit was ~ 32k.





Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
