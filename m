Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYLITqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYLITqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYLITp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:45:57 -0500
Received: from mail-fx0-f19.google.com ([209.85.220.19]:63392 "EHLO
	mail-fx0-f19.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYLITp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:45:57 -0500
X-Greylist: delayed 882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 14:45:56 EST
Message-ID: <493EC412.3090805@colorfullife.com>
Date: Tue, 09 Dec 2008 20:16:34 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, linux-kernel@vger.kernel.org,
       Holger Hoffstaette <holger@wizards.de>, netdev@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       stable@kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Try reverting the idr patch that went into 2.6.27.8. It broke DRM in the
> Fedora kernel at least.
>
>   
What happens?
Does it oops, does one of the BUG() statements trigger?

--
    Manfred
