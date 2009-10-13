Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZJMJxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZJMJxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZJMJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:53:09 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:24400 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZJMJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:53:08 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AD44DD3.4070508@tremplin-utc.net>
Date: Tue, 13 Oct 2009 11:52:19 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work	anymore
References: <4AD120F2.3020606@tremplin-utc.net> <20091011030029.GA6526@suse.de> <200910112135.29384.dmitry.torokhov@gmail.com> <4AD31709.4000103@tremplin-utc.net> <20091012154846.GB7996@core.coreip.homeip.net>
In-Reply-To: <20091012154846.GB7996@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-10-09 17:48, Dmitry Torokhov schreef:
> On Mon, Oct 12, 2009 at 01:46:17PM +0200, Éric Piel wrote:
>>> Eric, do you still need to fiddle with i8042 to get your keyboard working with 
>>> 2.6.32-rc3? We need to make sure that resube works without users needing to 
>>> mess with bind/unbind.
>> Yes, the keyboard doesn't work after the first resume from ram (the
>> later resumes do work). I haven't tried any special option to the i8042
>> driver. This is on a HP 2510, in 64 bits.
> 
> Could you please try and let me know if unloading at suspend and
> reloading after resume atkbd and/or psmouse drivers and leaving i8042
> alone "fixes" the issue?
> 
Unloading the modules before suspend and reloading them after works
around the issue, indeed.

Eric
