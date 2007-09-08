Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXIHV3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXIHV3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 17:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXIHV3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 17:29:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXIHV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 17:29:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: Suspend and hibernation status report
Date: Sat, 8 Sep 2007 23:40:36 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <200707271057.05438.rjw@sisk.pl> <200709041932.21281.lenb@kernel.org>
In-Reply-To: <200709041932.21281.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709082340.37018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 September 2007 01:32, Len Brown wrote:
> On Friday 27 July 2007 04:57, Rafael J. Wysocki wrote:
> 
> Thanks for writing this, Rafael.
> 
> > * system hibernation state - state, in which the system's processors are off and
> >   its main memory is not powered, but the information necessary for continuing
> >   the computations carried out when the system was last in a working state is
> >   preserved in a storage space, such as a disk
> > * ACPI S4 state - system hibernation state, in which some information is
> >   preserved by the ACPI platform, in accordance with the ACPI specification
> 
> "some information is preserved by the ACPI platform" is sort of mis-leading.
> What ACPI adds to the hibernate flow is some platform hooks to handle
> wakeup devices, and a platform hook for the actual sleep request.
> I'm not aware of any information saved by ACPI during S4 that is
> not saved were the hibernate to be done with "acpi=off".

Well, I am.

On HPC nx6325 the status of AC adapter after the restore is not reported
correctly if hibernation is done without the ACPI hooks (eg. if you hibernate
with the AC connected and then disconnect it and resume, it will still be
reported as connected until you plug/unplug it).

There are more machines that behave similarly, AFAICT.

Greetings,
Rafael
