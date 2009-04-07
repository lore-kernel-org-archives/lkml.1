Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZDGNFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZDGNFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDGNFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:05:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64865 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZDGNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OZiWhQd+V3UciiWMr1m2e1eXgrHagMrkFivtXmcRYfkd5S5Rv0KahXx5s0UZ5nhb22
         velh98hp0gaj0DwUqLcGmEG9U51PJ7G9YBphRgaDtn0+UIZ9blvDz/PSU3E8CmxHXI1g
         JnSi3GKXC3rpGUaeyVJc0//zgg7m3aDq9vkPY=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239109001.22453.40.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:04:57 +0300
Message-Id: <1239109497.15015.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 14:56 +0200, Johannes Berg wrote:
> On Tue, 2009-04-07 at 15:51 +0300, Maxim Levitsky wrote:
> 
> > > > I noticed that always first attempt at scan fails when NM asks for scan.
> > > > I also noticed that this happens with quite recent kernels (I think
> > > > 2,6.28) didn't have this behavior.
> > > 
> > > I'm pretty sure it did.
> 
> > I am sure that on older kernel there was no -EBUSY error returned to
> > userspace. It probably just stalled the client.
> 
> Can't imagine it did, maybe it just dropped the request though without
> indicating an error.
Very likely.

> 
> > > > Looking a bit deeper I discovered that each time NM disconnects from a
> > > > networks it sets random ssid/essid to the card (using wireless
> > > > extensions)
> > > 
> > > This forces a scan
> > > 
> > > > After that scan fails for some time.
> > > > 
> > > > as a NM free example you can run 
> > > > 
> > > > iwconfig wlan0 essid dummy
> > > > iwlist scan
> > > 
> > > and then this fails with EBUSY.
> > Thanks for explanation.
> > Since NM has its reasons to clear essid (to prevent unwanted
> > association), then what can be  done to prevent this (and still use
> > wireless extensions, since nl80211 support isn't yet mature)?
> 
> Nothing. Wext sucks, news at 11, yadda.
Thanks.
Everything understood.


Best regards,
	Maxim Levitsky

> 
> johannes

