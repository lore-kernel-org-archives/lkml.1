Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbYF3QNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbYF3QNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYF3QNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:13:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYF3QNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:13:35 -0400
Subject: Re: [Bug #10861] 2.6.26-rc4-git2 - long pause during boot
From: Kay Sievers <kay.sievers@vrfy.org>
To: chris2553@googlemail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
In-Reply-To: <200806301601.59199.chris2553@googlemail.com>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.BRF.E89ZIB@albercik>
	 <200806301601.59199.chris2553@googlemail.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 18:13:45 +0200
Message-Id: <1214842425.24597.4.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ZkTQwix3QdquiJCI4nvIXXFwWVapVfAGOfP5
 KfjC8O3T6as4vAC0f8gkn1oQwV54hncPRGN6PBXVBeFx+tEaOI
 hu4mpOJ00rquIVL/0NknN+85QmSRupZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 16:01 +0000, Chris Clayton wrote:
> On Sunday 29 June 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> 
> As far as I'm concerned, the entry can be closed..

I think so too.

> As I've said before, the 
> patch did have a bad effect on existing user space, but, as Kay pointed out, 
> there's no getting away from the fact that the rule in Slackware rules 
> distributed with udev is a bad rule. the Slackware distribution does not 
> include that rule in its udev rules.
> 
> I assume Kay will fix it in the udev package.

It was fixed in the udev package on 11 Mar 2007. But since a while, the
whole rule is deleted, as it is not needed for newer kernels, which have
proper SCSI sysfs timing.

Thanks,
Kay

