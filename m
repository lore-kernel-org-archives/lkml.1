Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYFRJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYFRJ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFRJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:28:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:19701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYFRJ2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,663,1204531200"; 
   d="scan'208";a="398783538"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Patch v2] Implement thermal limiting in the generic thermal class
Date: Wed, 18 Jun 2008 17:28:01 +0800
Message-ID: <823A93EED437D048963A3697DB0E35DE0171191C@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080617185345.GA5847@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch v2] Implement thermal limiting in the generic thermal class
Thread-Index: AcjRIfrUNXo9e6CVSSmiw3Npt/WIUQAACl1Q
References: <20080611100647.GA20013@srcf.ucam.org> <20080616085544.GA17813@srcf.ucam.org> <20080616092648.GA18506@srcf.ucam.org> <20080617185345.GA5847@ucw.cz>
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Pavel Machek" <pavel@suse.cz>, "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <trenn@suse.de>
X-OriginalArrivalTime: 18 Jun 2008 09:28:04.0629 (UTC) FILETIME=[9C4C2450:01C8D125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing I'm concerning is that if we could enable polling in Linux.
Bug #8842 shows that polling may break some laptops.
And we have known that windows never enable polling.
Although this patch will not break the laptop in #8842, it still may
bring some potential risks if we enable polling in Linux.
IMO, a dmi entry would be much more acceptable...

Thanks,
rui

>-----Original Message-----
>From: Pavel Machek [mailto:pavel@suse.cz]
>Sent: Wednesday, June 18, 2008 2:54 AM
>To: Matthew Garrett
>Cc: Zhang, Rui; linux-acpi@vger.kernel.org;
linux-kernel@vger.kernel.org
>Subject: Re: [Patch v2] Implement thermal limiting in the generic
thermal class
>
>Hi!
>
>> In the absence of an explicitly defined passive cooling zone any
>> machine unable to manage its thermal profile through active cooling
will
>> reach its critical shutdown temperature and power off, resulting in
>> potential data loss. Add support to the generic thermal class for
>> initiating passive cooling at a temperature defaulting to just below
the
>> critical temperature, with this value being overridable by the admin
via
>> sysfs.
>
>This means we get two copies of passive cooling code: one generic, and
>one in acpi. Can we make sure we have just one of them?
>
>--
>(english) http://www.livejournal.com/~pavelmachek
>(cesky, pictures)
>http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
