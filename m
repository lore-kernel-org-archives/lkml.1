Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXLIOFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXLIOFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXLIOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:05:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXLIOFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:05:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sun, 9 Dec 2007 15:24:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071209035415.a3875df8.akpm@linux-foundation.org>
In-Reply-To: <20071209035415.a3875df8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091524.13225.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Andrew Morton wrote:
> On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message contains a list of some regressions from 2.6.23 which have been
> > reported since 2.6.24-rc1 was released and for which there are no fixes in the
> > mainline that I know of.
> 
> Here's one for you - I have a new Lenovo t61p with which to irritate
> everyone. 
> 
> suspend-to-ram is a wipeout, but suspend-to-disk works OK under
> 2.6.23.
> 
> However under 2.6.24-rc1 and -rc4 the machine reboots right at the end of
> resume-from-disk.

It's http://bugzilla.kernel.org/show_bug.cgi?id=9258 , I think.

Does it do that if you unload ehci-hcd before the hibernation?
