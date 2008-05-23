Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYEWQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYEWQvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYEWQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:51:05 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34875 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYEWQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:51:04 -0400
Message-ID: <4836F68D.4090603@keyaccess.nl>
Date: Fri, 23 May 2008 18:53:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into kernel
 image
References: <1211550282.28967.8.camel@pmac.infradead.org> <20080523162101.GA31107@uranus.ravnborg.org> <20080523163841.GC27128@csclub.uwaterloo.ca> <20080523164447.GB31545@uranus.ravnborg.org>
In-Reply-To: <20080523164447.GB31545@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-05-08 18:44, Sam Ravnborg wrote:

> On Fri, May 23, 2008 at 12:38:41PM -0400, Lennart Sorensen wrote:
>> On Fri, May 23, 2008 at 06:21:01PM +0200, Sam Ravnborg wrote:
>>> Looks good.
>>> But do we need the firmware after init?
>>> In other owrds could it be inside a discard after init block?
>> What is you can hotplug the device and hence need to initialize the same
>> device type multiple times?  Wouldn't keeping the firmware around be
>> useful then?  How about on suspend/resume, do you need to reload
>> firmware in those cases?
> 
> There are cases where we need it after init.
> But if there are cases where we do not need it after init maybe
> we should be able to save some memory there?
> 
> Let us get it working as is - then we can add such features later.

If embedded is the main consumer I would consider this a fairly vital 
feature though.

Rene.
