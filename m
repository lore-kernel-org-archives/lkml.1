Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYANT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYANT06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYANT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:26:46 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:38504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYANT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:26:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WDDta6jnKTvFBGPiiIEGTIeaqcoX4WfESxDc95suwEjAm/IXJPMQE7OTs5P49TnrivpChO44uPhB94xtfyFWHmbD+ScdkvfQRf7TmA3WzzAkjRDLtcNce7Imf792MTf+Te80rpdyV9znObT/p02hQP+1O8K75qe8Dgm3UUmiNTk=
Message-ID: <43e72e890801141126t21480e69wc024c2fdc236af52@mail.gmail.com>
Date: Mon, 14 Jan 2008 14:26:42 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 rate control doesn't work
Cc: "Michael Wu" <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4787F03E.6080605@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477F9890.5050107@hauke-m.de>
	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	 <47824D25.5090005@hauke-m.de>
	 <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
	 <4787F03E.6080605@hauke-m.de>
X-Google-Sender-Auth: 84921234f631f3a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 5:39 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Luis R. Rodriguez wrote:
> > On Jan 7, 2008 11:02 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >
> > Thanks for reporting this, how'd it go with simple rate control
> > algorithm instead?
>
> How do I change from pid to simple rate control algorithm?

In config.mk replace this line:

CONFIG_MAC80211_RC_DEFAULT=pid

with:

CONFIG_MAC80211_RC_DEFAULT=simple

although I am planning on changing the config stuff soon.

  Luis
