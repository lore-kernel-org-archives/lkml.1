Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZKPCyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZKPCyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZKPCyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:54:52 -0500
Received: from mta21.charter.net ([216.33.127.81]:51094 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZKPCyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:54:51 -0500
X-Greylist: delayed 94690 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 21:54:51 EST
X-Authority-Analysis: v=1.0 c=1 a=sAFGdaRh2doA:10 a=hOpmn2quAAAA:8
 a=D7HV_HDsCjdMOG3DZ6QA:9 a=b-cvOOEGqK0hhBuzpwQA:7
 a=0S3aQc3l3Y6dt29b3SpfdO8pH8kA:4 a=hUswqBWy9Q8A:10
From: Steve Meisner <smeisner@charter.net>
Organization: SCME
To: linux-kernel@vger.kernel.org
Subject: Parallel Driver(s) Broke in 2.6.31
Date: Sun, 15 Nov 2009 21:54:47 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.29.6-desktop-2mnb; KDE/4.3.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911152154.47510.smeisner@charter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted to the Mandriva forum with no luck yet.  I recently upgraded to 
Mandriva 2010.0 and in doing so lost ability to use my parallel printer.  
After many hours of debugging effort and finding nothing in logs or 
hardware/driver error messages, I went on a hunch that it could be related to 
the kernel.  So I rolled back to the 2009.1 kernel 2.6.29 and printing 
returned.  I don't know how to proceed with determining the root cause as I 
cannot find any error in the logs or differences in hardware detection and 
module loading.  I don't even know the hierarchy of the modules involved 
(parport, parport, pc, lp, and ppdev).   Should I start diffing those modules 
and see if I get lucky applying hacking 101 techniques?  Please CC me 
(smeisner@charter.net) if you have any suggestions (except for buying a new 
printer).
Thanks,

-- 

Steve Meisner
