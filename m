Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZFIIHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZFIIHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbZFIIHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:07:14 -0400
Received: from mxs2.siemens.at ([194.138.12.133]:60064 "EHLO mxs2.siemens.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758960AbZFIIHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:07:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Catch program crash, and collect core dump.
Date: Tue, 9 Jun 2009 10:07:08 +0200
Message-ID: <89AFFE04075E4449A469671466FA948549ACC6@nets11ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Catch program crash, and collect core dump.
Thread-Index: AcnoQ+F2LwuKlJbeTPK9l8IhxG+iWAAlSS8gAAAC8yA=
From: "Naray, Gabor" <gabor.naray@siemens-enterprise.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jun 2009 08:07:07.0981 (UTC) FILETIME=[489177D0:01C9E8D9]
X-purgate: clean
X-purgate: This mail is considered clean
X-purgate-type: clean
X-purgate-Ad: Checked for Spam by eleven - eXpurgate www.eXpurgate.net
X-purgate-ID: 149917::090609100719-088A3BA0-1F1C69B3/0-0/0-15
X-purgate-size: 1435/999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I would like to create a small daemon which can recognize if 
a user-space program crashes, and can collect the core dump 
of that program, but could also perform additional tasks.
I am looking for something like a /proc configuration, which 
can define what to do, if a program crashes. I haven't found 
anything like that.

Right now, my best bet is something like this: ``echo 
"/tmp/corefiles/core" > /proc/sys/kernel/core_pattern'', and 
then monitor the directory with inotify.

We are developing an application which stands from multiple 
modules, and generates detailed logs, which under heavy load 
can rotate out under 10 sec. Therefore we need to save these 
logs as soon as possible in case of a crash. Polling the 
crash logs is not an option (the more it is loaded, the less 
we should poll, but the more we need to catch in time). 

Best solution would be, if a command could be configured 
which is triggered in case of a user-space crash.

I have found ``apport'', as a project which does something 
like that, but I couldn't figure it out yet, how it does 
that. I haven't found any entries regarding this problem in 
the list archives.

If you have any idea - other than my suggestion -, please help me.
 
Best regards,
Gábor Náray.
 
PS: I am not subscribed to the mailing list, so please CC me 
directly into the answers.
 
 
