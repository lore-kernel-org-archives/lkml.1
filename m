Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYBOPhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYBOPhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYBOPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:37:05 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23239 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbYBOPhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:37:03 -0500
Message-ID: <47B5B19C.9020801@msgid.tls.msk.ru>
Date: Fri, 15 Feb 2008 18:37:00 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Spurious completions during NCQ
References: <20080215134658.GB27745@vlad.carfax.org.uk> <1203087600.25150.5.camel@zem> <20080215150449.GC27745@vlad.carfax.org.uk>
In-Reply-To: <20080215150449.GC27745@vlad.carfax.org.uk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugo Mills wrote:
> On Fri, Feb 15, 2008 at 10:00:00AM -0500, Calvin Walton wrote:
>> On Fri, 2008-02-15 at 13:46 +0000, Hugo Mills wrote:
>>> I'm getting these on my Dell Latitude D830:
>>>
>>> Feb 15 13:06:00 willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
>>> Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002
>>>    In some cases, there are several cmd/res lines listed. It's
>>> happening about once an hour or so (not correlated with any other
>>> event that I can see). It doesn't seem to be affecting operation of
>>> the machine, but it's making me nervous.

JFYI: Most probably it is correlated with smartd asking
the device for it's SMART status.

/mjt
