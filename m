Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXCOTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXCOTpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbXCOTpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:45:24 -0400
Received: from gw.goop.org ([64.81.55.164]:44234 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208AbXCOTpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:45:23 -0400
Message-ID: <45F9A250.7040409@goop.org>
Date: Thu, 15 Mar 2007 12:45:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
References: <20070313040828.GA17893@redhat.com> <200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com> <m1d53apjvu.fsf@ebiederm.dsl.xmission.com> <20070315181059.GA1644@redhat.com>
In-Reply-To: <20070315181059.GA1644@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> I just did a build of top of tree, including those commits, and
> it's still broken.  Booting with pci=nomsi no longer 'fixes' it
> though, which may indicate that the MSI changes were a red herring.
> (Or that the subsequent changes have regressed it even more,
>  which seems unlikely looking at the changes).
>   

I just found the same thing on my X60.  Current top-of-tree with
pci=nomsi does not improve things.  When it resumes, the CPU is working
(capslock toggles, sysreq-b reboots), but the screen is blank.

I was about to try 2.6.21-rc3-mm2; I'll see if that's any different.

    J
