Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYEZJAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYEZJAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYEZJAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:00:37 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:8643 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYEZJAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XS9wGU9CM6H/83vpKp+p2sCi2twtE/gQDdxNJDa+XBds/ZwmpWN0qLJolj2ZK0yBUAvci2LR2t1asWZn2T9BG0cPA8tqokGhbSDNVOBqXjeQzFs8kDYDwaLU3nd6oPeCAKrorqWTchUbiHOyM/vTEkJH3PBWLyr8yceSXIkPbMg=
Message-ID: <1ba2fa240805260200j3ffaac03yf0966aacc57a65b6@mail.gmail.com>
Date: Mon, 26 May 2008 12:00:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: regression iwl3945/mac80211: association times out since 2.6.26-rc1
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
In-Reply-To: <20080526054040.GA7207@robinhood.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520184859.GA8168@robinhood.home>
	 <20080521054743.GA9910@robinhood.home>
	 <20080524182852.GA9722@robinhood.home>
	 <1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
	 <20080526054040.GA7207@robinhood.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 8:42 AM, Michael S. Tsirkin
<m.s.tsirkin@gmail.com> wrote:
> On Sun, May 25, 2008 at 02:24:28AM +0300, Tomas Winkler wrote:
>> On Sat, May 24, 2008 at 9:29 PM, Michael S. Tsirkin
>> <m.s.tsirkin@gmail.com> wrote:
>> > On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
>> >> FYI, I created an item in bugzilla to track this
>> >> http://bugzilla.kernel.org/show_bug.cgi?id=10765
>> >
>> > As requested, more configuration and log files have been attached
>> > to this item.
>>
>> It looks like also this issue should be fixed by ' mac80211: reorder
>> channel and freq reporting in wext scan report' patch.
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/15177
>> Please try.
>> Thanks
>> Tomas
>
> I can confirm that the patch linked above has solved the regression for me.
> Is it queued for 2.6.26?

Hope so, it should go also to 25 If I remember someone posted version
that matched the old file name
as well.
Thanks
Tomas
