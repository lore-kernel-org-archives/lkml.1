Return-Path: <linux-kernel-owner+w=401wt.eu-S935527AbXJPVGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935527AbXJPVGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbXJPVFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:05:55 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42276
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXJPVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:05:54 -0400
Date: Tue, 16 Oct 2007 14:10:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Rik van Riel <riel@surriel.com>, Mark Gross <mgross@linux.intel.com>,
       Giacomo Catenazzi <cate@debian.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: <Pine.LNX.4.64.0710162224570.4548@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710161408240.6995@asgard.lang.hm>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com>
 <20071015183017.GB23130@uranus.ravnborg.org> <4713C582.4000504@debian.org>
 <20071016200623.GB23157@linux.intel.com> <Pine.LNX.4.64.0710162207540.4548@fbirervta.pbzchgretzou.qr>
 <20071016162310.1891914f@bree.surriel.com> <Pine.LNX.4.64.0710162224570.4548@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Jan Engelhardt wrote:

> On Oct 16 2007 16:23, Rik van Riel wrote:
>
>>>> base function:
>>>> Starting from a stock distro (FC, Ubuntu, OpenSuSE...) and put down a
>>>> kernel.org tree and automatically create a .config with all the
>>>> drivers needed for the platform I'm building on.
>>>
>>> Too easy. Since opensuse's udev loads most of the modules for your
>>> hardware, all that would be needed is to transform the lsmod list of
>>> modules plus the static options in /proc/config.gz (stuff like
>>> psmouse) back into kconfig options ;-)
>>
>> Well, at that point it does not know whether or not you
>> occasionally plug in an ipod or a digital camera.
>
> Which is why building an allmod kernel (or what the distros do)
> is IMO the better solution.

if all you want is a config that will work you are right.

however if you want a good base for an optimized, minimal kernel it's not 
much help (other then possibly as a stepping stone to then examine all the 
modules that were loaded and document which ones are needed)

David Lang
