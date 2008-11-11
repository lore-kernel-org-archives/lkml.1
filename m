Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYKKXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYKKXnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYKKXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:43:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYKKXnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:43:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Wed, 12 Nov 2008 00:48:06 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <200811111516.09163.rjw@sisk.pl> <20081111181925.GA5036@dose.home.local>
In-Reply-To: <20081111181925.GA5036@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811120048.06647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Tino Keitel wrote:
> On Tue, Nov 11, 2008 at 15:16:08 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > This really is not a good news, because this commit evidently fixes at least
> > several systems.
> > 
> > First, let's try to remove things that we shouldn't be doing.
> > 
> > Please apply the patch below to 2.6.27.5 without reverting that commit and see
> > if that works.
> 
> It doesn't work. 2.6.27.5 with the patch applied hangs at resume.

Well, this appears to be a broken BIOS thing.  Perhaps we'll have to blacklist
the box or something.

Is there any possibility to get some information about where exactly it hangs?

Rafael
