Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXEKNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXEKNmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXEKNmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:42:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:44211 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:42:36 -0400
X-IronPort-AV: i="4.14,523,1170651600"; 
   d="scan'208"; a="29669039:sNHT23300900"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Chris Smith" <smitty1elkml@gmail.com>
Subject: Re: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
Date: Fri, 11 May 2007 09:44:56 -0400
User-Agent: KMail/1.9.5
Cc: "Arne Georg Gleditsch" <argggh@dolphinics.no>, devzero@web.de,
       linux-kernel@vger.kernel.org, jcm@redhat.com
References: <1783741195@web.de> <873b23ivr2.fsf@pelargir.dolphinics.no> <9b53a56d0705110525o336eb0b8sb963d95608c94b9@mail.gmail.com>
In-Reply-To: <9b53a56d0705110525o336eb0b8sb963d95608c94b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110944.56699.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 11 May 2007 13:42:34.0505 (UTC) FILETIME=[3AF74F90:01C793D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11 May 2007 08:25, Chris Smith pondered:
>
> Now, if you merged the beauty of LXR with the wiki goodness of
> kernelnewbies.org, and somehow kept it current <waves hands> that
> could be cool.
> --

We made a plugin to dokukwiki - that grabs our maintained kernel source from 
our scm system, and display it in our wiki. It helps to see the text 
explanation, and the actual up todate code. (no maintenance when code is 
updated) It also automatically inserts some links to the scm web interface.

An example is at here:
http://docs.blackfin.uclinux.org/doku.php?id=interrupts#interrupt_discovery

Things to do:
 - doesn't support git today - but should be a trivial change
 - links to lxr - again pretty trivial
 - write a cron that goes through the wiki source daily, poking someone to 
check the wiki text when the source changes.

-Robin
