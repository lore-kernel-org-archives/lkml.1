Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYIBNVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYIBNVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYIBNU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:20:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:60013 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYIBNUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uDKOC38x9shRrCKp4X/QrQ6TGILZbMN0pE/c7UCtklHb0Wi5tB1QZKPS+slzx5RKb0
         ModsZr8lownGaKy9/BOmllg5XKqa9G4Dp4E3SojuNg5fiD/0N7hY3Lntv1Ls44fOlk+E
         dHOiS32nFlp90hvxBmjmEGPF0G3nxXaXdvqy4=
Date: Tue, 2 Sep 2008 16:20:48 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902132045.GD19172@google.com>
References: <20080901160658.GA11063@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901160658.GA11063@google.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 07:06:58PM +0300, Michael S. Tsirkin wrote:
> Starting with 2.6.27-rc5, my T60p sometimes fails to associate
> with an access point after suspend to ram/resume.
> 
> This does not seem to ever happen on 2.6.27-rc4.
> 
> When this happens, I observe the following messages in dmesg:
> (AP mac masked out with XX):
> 
> ...
>  
> Reverting 8ab65b03b7893da4a49009e7e356e36e27b0c407 seems to make
> the card associate properly after suspend, for me.

FYI I created a bugzilla entry to track this:
http://bugzilla.kernel.org/show_bug.cgi?id=11476

-- 
MST



