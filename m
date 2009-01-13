Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZAMLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZAMLpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAMLpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:45:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZAMLpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:45:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: Regression 2.6.28-git: suspend/resume failure. git bisected to usb suspend/resume patch
Date: Tue, 13 Jan 2009 12:44:49 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
References: <200901111348.46216.borntraeger@de.ibm.com> <200901121825.20943.rjw@sisk.pl> <b6a2187b0901122044v1828eeb3lbe1a57367b4862a1@mail.gmail.com>
In-Reply-To: <b6a2187b0901122044v1828eeb3lbe1a57367b4862a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131244.49960.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Jeff Chua wrote:
> On Tue, Jan 13, 2009 at 1:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Please see if reverting commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> > (cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write) in
> > addition to a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 helps.
> 
> I can confirm that with these two commits reverted, my X61 can resume from STD.
> 
> > Also, please check if the appended patch fixes the issue with
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> 
> This patch does not apply cleanly to the latest git pull.

I've just sent you a version that should apply to it in another thread.

Thanks,
Rafael
