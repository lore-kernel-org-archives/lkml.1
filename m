Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZFCJBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZFCJBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZFCJB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:01:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZFCJB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:01:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
Date: Wed, 3 Jun 2009 11:01:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se> <200906012133.32074.rjw@sisk.pl> <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
In-Reply-To: <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031101.56577.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009, Magnus Damm wrote:
> 2009/6/2 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Monday 01 June 2009, Rafael J. Wysocki wrote:
> >> On Monday 01 June 2009, Magnus Damm wrote:
> >> > From: Magnus Damm <damm@igel.co.jp>
[--snip--]
> 
> If you guys dislike adding arch specific data to struct platform
> device then for SuperH we can just (mis)use the arch specific data in
> struct device instead. I'm afraid that solution wastes memory since
> the data will only be used for platform devices anyway. So I prefer
> adding arch specific data to struct platform_device instead of struct
> device if possible.

BTW, what is the difference really?  You can always put
dev.platform_data = NULL for devices that don't have any platform data,
can't you?

Rafael
