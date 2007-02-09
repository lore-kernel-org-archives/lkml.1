Return-Path: <linux-kernel-owner+w=401wt.eu-S2992452AbXBIRoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992452AbXBIRoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992453AbXBIRoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:44:04 -0500
Received: from wbmler2.mail.xerox.com ([13.13.138.217]:42680 "EHLO
	wbmler2.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992452AbXBIRoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:44:03 -0500
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 12:44:02 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: force insmod on 2.6
Date: Fri, 9 Feb 2007 12:27:32 -0500
Message-ID: <556445368AFA1C438794ABDA8901891C034456F2@usa0300ms03.na.xerox.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: force insmod on 2.6
thread-index: AcdMb5UEOIyDzzUQTRGH3levdAs8uQ==
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: <linux-kernel@vger.kernel.org>
Cc: <leisner@rochester.rr.com>
X-OriginalArrivalTime: 09 Feb 2007 17:27:33.0619 (UTC) FILETIME=[95796430:01C74C6F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had modules which were compiled with another kernel version string
(same kernel though).

In 2.4, you could do a force in the modules.conf files or in the insmod
command line.

The current insmod doesn't have a force option.

Modprobe CAN force, but the modules has to be in the modules tree (i.e.
not arbitrary places on the 
file system)

Is there a way to force load a module at an arbitrary location?

This is very handy for development (not production).

marty
