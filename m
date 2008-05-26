Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYEZFml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYEZFml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 01:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYEZFmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 01:42:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:58040 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYEZFmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 01:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Q5kjFNXFqcXmxe15h2uTdytL5mXqaXJ09B2+V9B7HpUaBCodw7+1YpK2mg9OkQYyumGpGJTwuq7KG/gHmCZ25T7y0KYGkdn6N9xHBSVVy0Mi8etLvx0uUmtsfCEaXeIFLrUP6MdNqNrom+H8xm72XP0CkdIsTMa7Tdwg7yMcRnk=
Date: Mon, 26 May 2008 08:42:26 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
Subject: Re: regression iwl3945/mac80211: association times out since
	2.6.26-rc1
Message-ID: <20080526054040.GA7207@robinhood.home>
References: <20080520184859.GA8168@robinhood.home>
	<20080521054743.GA9910@robinhood.home>
	<20080524182852.GA9722@robinhood.home>
	<1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 02:24:28AM +0300, Tomas Winkler wrote:
> On Sat, May 24, 2008 at 9:29 PM, Michael S. Tsirkin
> <m.s.tsirkin@gmail.com> wrote:
> > On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
> >> FYI, I created an item in bugzilla to track this
> >> http://bugzilla.kernel.org/show_bug.cgi?id=10765
> >
> > As requested, more configuration and log files have been attached
> > to this item.
> 
> It looks like also this issue should be fixed by ' mac80211: reorder
> channel and freq reporting in wext scan report' patch.
> http://article.gmane.org/gmane.linux.kernel.wireless.general/15177
> Please try.
> Thanks
> Tomas

I can confirm that the patch linked above has solved the regression for me.
Is it queued for 2.6.26?

-- 
MST
