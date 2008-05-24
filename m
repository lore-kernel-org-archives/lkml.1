Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYEXXYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYEXXYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYEXXYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:24:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:37445 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYEXXYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qx2PBx3MhTZAzNv249uZUY1EN9RejMuPF7YputPhUTFXqs8lh/uUq2mF60ycQkWa3SzrMZUYk+FHAi+iIKtKrVWyPL+4J62g02bA0fn73fuWU7jxxsueyIZ6qWmu+01LfZb+Uwi9J9rlq3caPmVL2Nzf5sshUR6EYCcrrqfjl+I=
Message-ID: <1ba2fa240805241624t4999d108uef78b30408a5c545@mail.gmail.com>
Date: Sun, 25 May 2008 02:24:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: regression iwl3945/mac80211: association times out since 2.6.26-rc1
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
In-Reply-To: <20080524182852.GA9722@robinhood.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520184859.GA8168@robinhood.home>
	 <20080521054743.GA9910@robinhood.home>
	 <20080524182852.GA9722@robinhood.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 9:29 PM, Michael S. Tsirkin
<m.s.tsirkin@gmail.com> wrote:
> On Wed, May 21, 2008 at 08:47:44AM +0300, Michael S. Tsirkin wrote:
>> FYI, I created an item in bugzilla to track this
>> http://bugzilla.kernel.org/show_bug.cgi?id=10765
>
> As requested, more configuration and log files have been attached
> to this item.

It looks like also this issue should be fixed by ' mac80211: reorder
channel and freq reporting in wext scan report' patch.
http://article.gmane.org/gmane.linux.kernel.wireless.general/15177
Please try.
Thanks
Tomas
