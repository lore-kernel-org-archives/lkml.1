Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYCUI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYCUI43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 04:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYCUI4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 04:56:21 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:55345 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYCUI4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 04:56:21 -0400
Date: Fri, 21 Mar 2008 09:56:19 +0100
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: suspend not working on macbook pro
Message-ID: <20080321085619.GA12152@ojjektum.uhulinux.hu>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <20080309090155.GB3866@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309090155.GB3866@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 10:01:55AM +0100, Pavel Machek wrote:
> Hi!
> 
> > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > suspend. The console is still on, the disk is powered off, but no 
> > response or poweroff...
> > 
> > Did anyone else met the same thing? How could I help debug it?
> > What other info would you need?
> 
> Find more exact version when it broke? git bisect?

I did not have time for bisect, but I have found that if I boot an 
initrd and do not load the ata_piix module, suspend works, if I load it, 
it hangs during suspend.


-- 
pozsy
