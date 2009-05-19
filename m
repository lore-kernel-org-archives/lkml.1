Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZESHrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZESHrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZESHrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:47:02 -0400
Received: from engine29-1277-2.icritical.com ([212.57.248.116]:44002 "HELO
	engine29-1277-2.icritical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751769AbZESHrB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:47:01 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2009 03:47:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: linux-next: cputime tree build warning
Date: Tue, 19 May 2009 08:39:32 +0100
Message-ID: <4854F2500EA8C4478A508D2D92973E52046B8498@EXCHANGE25.fed.cclrc.ac.uk>
In-Reply-To: <20090519173251.86d755c8.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux-next: cputime tree build warning
Thread-Index: AcnYVAz6e3Mz1ppUQGOg3zC/UuirfQAAG1Ww
From: "Abbott, MG (Michael)" <michael.abbott@diamond.ac.uk>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 May 2009 07:39:33.0142 (UTC) FILETIME=[F3885360:01C9D854]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> fs/proc/uptime.c: In function 'uptime_proc_show':
> fs/proc/uptime.c:14: warning: unused variable 'len'
> 
> Introduced by commit ed7e789abfc433e46524419b7cc51d949552505e 
> ("[PATCH]
> Fix idle time field in /proc/uptime") from the cputime tree.

Ouch.  I do apologise.  The (now) bogus variable len must have been
preserved when I rebased from 2.6.29.3 to current git, and I guess I
didn't spot the warning among all the other warnings in the build.

--
I'm very sorry about the junk below generated from this account.
This e-mail and any attachments may contain confidential, copyright and or privileged material, and are for the use of the intended addressee only. If you are not the intended addressee or an authorised recipient of the addressee please notify us of receipt by returning the e-mail and do not use, copy, retain, distribute or disclose the information in or attached to the e-mail.
Any opinions expressed within this e-mail are those of the individual and not necessarily of Diamond Light Source Ltd. 
Diamond Light Source Ltd. cannot guarantee that this e-mail or any attachments are free from viruses and we cannot accept liability for any damage which you may sustain as a result of software viruses which may be transmitted in or with the message.
Diamond Light Source Limited (company no. 4375679). Registered in England and Wales with its registered office at Diamond House, Harwell Science and Innovation Campus, Didcot, Oxfordshire, OX11 0DE, United Kingdom
 
