Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYGKTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYGKTER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGKTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:04:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYGKTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:04:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Date: Fri, 11 Jul 2008 21:05:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214584985.22228.15.camel@localhost> <200807092300.59678.rjw@sisk.pl> <20080711153815.GA7109@deprecation.cyrius.com>
In-Reply-To: <20080711153815.GA7109@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112105.20917.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Martin Michlmayr wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-07-09 23:00]:
> > This is a symptom of the userspace resume trying to feed invalid image
> > metadata to the kernel (yes, I'll have to change that code to return error
> > code in that case).
> > 
> > Please try to run mkswap on your resume partition and see if that helps.
> 
> Nope, I'm still getting the same.

If you have the user space resume utility in your initrd, please try to disable
or remove it.  I'd like to verify if it is responsible for this message.

Thanks,
Rafael
