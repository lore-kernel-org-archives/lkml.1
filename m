Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZAMMpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZAMMpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZAMMo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:44:56 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:56991 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZAMMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:44:55 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Tue, 13 Jan 2009 13:42:44 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl>
In-Reply-To: <200901131239.21995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131342.44562.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 Januar 2009 schrieb Rafael J. Wysocki:
> On Tuesday 13 January 2009, Pavel Machek wrote:
> > Hi!
> > 
> > Just when I thought long merge window means less problems...
> > 
> > ...suspend seemed to work until last tuesday or so. Now it hanged two
> > times; once so hard that power button powercycle did not result in
> > booting machine. (thinkpad x60)
> > 
> > I'll do some more tests...
> 
> There are a couple of things you may want to revert, like
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> 
> Please let me know if that helped.

I tested rc1+ these two reverts yesterday on my T61p. Doesnt work. There must 
be at least one more patch that broke S2R on my thinkpad. In fact, it is cpu 
hotplug that is broken (unplug works).

I will try to bisect that as well, but currently I am busy trying to find a 
virtio regression....

Christian
