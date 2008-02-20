Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYBTN1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYBTN1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYBTN1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:27:22 -0500
Received: from mail.southpole.se ([193.12.106.18]:43209 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYBTN1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:27:21 -0500
Message-ID: <47BC2AB7.4040402@southpole.se>
Date: Wed, 20 Feb 2008 14:27:19 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, greg@kroah.com
Subject: Re: pci_device_id cleanups
References: <1203512031-14318-1-git-send-email-jonas@southpole.se> <20080220131704.GB18790@uranus.ravnborg.org>
In-Reply-To: <20080220131704.GB18790@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Feb 20, 2008 at 01:53:36PM +0100, Jonas Bonn wrote:
>> The PCI_DEVICE_TABLE patch I sent earlier doesn't necessarily make
>> much sense by itself... here is a set of patches that apply
>> this macro, in turn moving a lot of this data into __devinitconst
>> which is discardable in certain situations.
>> Hopefully the benefit of this approach is a bit clearer now.
> [shorter lines please..]

Sorry...

> 
> Can you please confirm that this does not break powerpc (64 bit)
> as they have troubles with the constification..

I do not have access to any PowerPC machine... Olof Johansson built the 
tree I posted earlier on PowerPC; there's nothing really new here except 
the wrapping of the definition in a macro.

But of course, it would great if someone could confirm this...

> 
> 	Sam
> 

