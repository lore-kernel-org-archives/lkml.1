Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbYGFUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbYGFUFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYGFUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:05:26 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28792 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYGFUFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:05:25 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Sun, 6 Jul 2008 20:03:10 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: Acjfdz2Ng7JNl8UnRAKb5giIqGnH9wAKmmvA
Message-ID: <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <20080627191458.GA10872@ucw.cz>
In-Reply-To: <20080627191458.GA10872@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>> A driver for the HP iLO/iLO2 management processor, which allows
>> userspace programs to query the management processor.  Programs can
>> open a channel to the device (/dev/hpilo/dXccbN), and use this to
>> send/receive queries.
>
> What kind of queries? Is there documentation somewhere?

Generally, it can get data out of the management processor - things
like basic iLO configuration (users, nic, etc), handle SNMP traffic,
flashing iLO, and some others.

Unfortunately, there isn't yet any available documenation.

> If it can read temperature, it should hook itself into hwmon
> framework. Can it? What can it do?

It can't do temperature.
