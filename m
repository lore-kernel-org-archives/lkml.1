Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZG2U7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZG2U7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZG2U7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:59:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZG2U7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:59:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug 13865] New: Can only resume with HP_WMI selected on compaq nc6000 when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
Date: Wed, 29 Jul 2009 22:57:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
References: <bug-13865-10028@http.bugzilla.kernel.org/>
In-Reply-To: <bug-13865-10028@http.bugzilla.kernel.org/>
Cc: bugzilla-daemon@bugzilla.kernel.org, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292257.41573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, you wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13865
> 
>            Summary: Can only resume with HP_WMI selected on compaq nc6000
>                     when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is
>                     reverted
>            Product: Power Management
>            Version: 2.5
>     Kernel Version: 2.6.30
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Hibernation/Suspend
>         AssignedTo: power-management_other@kernel-bugs.osdl.org
>         ReportedBy: cedric@belbone.be
>         Regression: No
> 
> 
> Just for testing I enabled HP_WMI. But from then, I could not resume anymore.
> I just reverted the last git commit on the 'drivers/platform/x86/hp-wmi.c' code
> (4c395bdd3f2ca8f7e8efad881e16071182c3b8ca) and now I can resume.
> The problem still persists on .31-rc serie

Frans, that's something for you to take care of.

Best,
Rafael
