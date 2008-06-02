Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYFBSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYFBSlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFBSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:41:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYFBSlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:41:06 -0400
Message-ID: <48443EB3.8020303@garzik.org>
Date: Mon, 02 Jun 2008 14:40:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: rwheeler@redhat.com
CC: kristen.c.accardi@intel.com, Mark Lord <liml@rtr.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org>	<20080602080440.25fc663c@core>	<4843A4A7.3020809@garzik.org>	<4843EF88.2040606@rtr.ca>	<48441AA6.8080704@garzik.org>	<20080602100019.3d2d2522@appleyard>	<484431AB.7010005@garzik.org>	<20080602104753.3f24087d@appleyard>	<484438BF.7070303@garzik.org> <20080602111644.54738d57@appleyard> <48443C3C.3010401@redhat.com>
In-Reply-To: <48443C3C.3010401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Kristen Carlson Accardi wrote:
>> Not all drivers will need a user interface to turn off hotplug
>> I would think.  At any rate - I would think it'd be better to let
>> driver writers decide how they want their drivers to behave wrt
>> hotplug and power instead of forcing a generic policy on everyone.
>>
>> This patch would provide users of AHCI controllers a way to save
>> power now, while you work on the grand scheme for polling/turning on off
>> hotplug via sysfs.  It's an interim solution that impacts nobody but
>> ahci users and is can be easily integrated into whatever solution you
>> eventually work out.

> I like the patch -  it seems that it will help a lot of users out near 
> term in a very positive way while we iterate on the broader solution,

A better patch would enable the _possibility_ of power savings on 
non-AHCI chips, and not add a one-off AHCI-specific user interface that 
must be supported for years to come.

	Jeff


