Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYIRSMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYIRSMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYIRSMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:12:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46506 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYIRSMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=IEcDPMmm/CQEIrEnmfAle3J/euxQymbr6lvbFfAXDYjUh9wCqce6xfgb/Sy0u57Sq4
         iEM10YisRg6zJMt8bHboCuMKO7ZiYyippFmrQGNSMYT02wqokKh1XQlDVLdorOhsMXRO
         8lq+RU2n2DebeIPxgLdAre+XRms7OjWkmiDBM=
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 20:12:18 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <200809181932.58272.IvDoorn@gmail.com> <1221760328.9262.94.camel@johannes.berg>
In-Reply-To: <1221760328.9262.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809182012.18723.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008, Johannes Berg wrote:
> On Thu, 2008-09-18 at 19:32 +0200, Ivo van Doorn wrote:
> 
> > Ideal situation would indeed be that mac80211 registers a rfkill structure
> > and listens to rfkill events. This would help drivers by only needing to
> > register a rfkill structure for state-change events without any need for
> > listeners.
> 
> Yup.
> 
> > I was considering such a patch some time ago, but needed to figure out
> > how to work with the state-override capabilities (HW_BLOCK and SOFT_BLOCK)
> > and didn't work on it any further since.
> 
> So make the struct part of the hw structure? Then drivers can just use
> that to force hard events. Or actually, no, don't do this, make a new
> mac80211 call:
> 
> 	ieee80211_inform_hardblocked(BLOCK/OPEN)
> 
> which makes sure we can also try to not associate in this case in the
> future...

Yeah, unfortunately that wasn't the probablematic part. ;)
Anyway when I have some time available I'll see if I can sort it out and
make it work. But that will not be for another week or 2.

Ivo
