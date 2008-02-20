Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYBTIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYBTIiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBTIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:38:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:60629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYBTIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:38:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rk9Wh4ujXcctzl1dSQAZigBCfzw2uLK692pKhW3JXC8GF4yPDxIHTKZcSbNRYoKf5sYylSfGgWynV1NzhupuPutnHgG1kWasZ8MJgMkBAvMPwJpK1iBdguzkdDYKspgztoMAGgklnNnb+/QhqNEbBLNtbMA4Hes274ZY/oBKXTk=
Message-ID: <1ba2fa240802200038l79ae3b31na7604c2fb692929@mail.gmail.com>
Date: Wed, 20 Feb 2008 10:38:04 +0200
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [2.6.25 patch] fix broken error handling in ieee80211_sta_process_addba_request()
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220064613.GA3885@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219225852.GQ31955@cs181133002.pp.htv.fi>
	 <20080220064613.GA3885@ff.dom.local>
X-Google-Sender-Auth: 49ed6195331ed93d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 8:46 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On 19-02-2008 23:58, Adrian Bunk wrote:
> ...
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -1116,9 +1116,10 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
> ...
> > +                     printk(KERN_ERR "can not allocate reordering buffer "
>
>   +                     printk(KERN_ERR "cannot allocate reordering buffer "
>
> Probably this can be fixed during the commit.
>
> Jarek P
.
ACK: both patches.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
