Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbYFMOHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbYFMOHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYFMOHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:07:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbYFMOHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:07:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Date: Fri, 13 Jun 2008 16:08:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       riel@redhat.com
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
In-Reply-To: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131608.31803.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 of June 2008, Zdenek Kabelac wrote:
> Hello
> 
> I'm attaching a trace where my machine has got into big troubles after
> 2 day usage and several successful suspend/resumes (this seems to be
> finally getting better now :))
> 
> It looks like while there was a huge amount of buffers and caches -
> system was unable to allocate few pages for kmalloc in iwl3945 driver
> after resume.
> 
> I've even tried to 3 > drop_cache  and reinsert iwl driver - but this
> had fatal results - machine died completely with blinking caps lock -
> and no oops in the log for this case:
> 
> This is the commit aab2545fdd6641b76af0ae96456c4ca9d1e50dad  for the
> 2.6.26-rc5 I've been in this case.

Is this a regression from 2.6.25, BTW?

Rafael
