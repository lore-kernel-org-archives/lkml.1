Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYEUUFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYEUUFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbYEUUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:04:56 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:38285 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758295AbYEUUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:04:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ALjyCKJCpktl956L11SuXMM6WHvTOQZvSrgxirWIj1vVS10OqE8Af6qDVKKxwYZDJv9OgBnuc5h0cw8SGSqtkQnumedMVRndlosvsN7O0Dsdf5nMP2DS0saeisGGsVhaX+G0z89EsOyOvdK8rJzzWLGbhHT3dMawRAIguybcy8U=  ;
X-YMail-OSG: LsvESPEVM1lWXRrPdri1SVRyFYfXSLV5o.wz6RSAWUNrtBdo8kKKuLi9fqIzStsHjkUrl6FM_LQh5Woq3zeDJ0da.pkYGHkFbw4C.ZukWDu7QN__5jRJrGWP6S8KgamYENPn8BRyCrqO_eBMH8NI0F0.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <me@felipebalbi.com>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Date: Wed, 21 May 2008 13:04:52 -0700
User-Agent: KMail/1.9.9
Cc: Tony Lindgren <tony@atomide.com>, Bryan Wu <cooloney@kernel.org>,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org> <200805211014.45170.david-b@pacbell.net> <61cdb2dcc22913ddefddd7b4a6faede3@felipebalbi.com>
In-Reply-To: <61cdb2dcc22913ddefddd7b4a6faede3@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805211304.53082.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Felipe Balbi wrote:
> 
> > I'm all for getting the musb_hdrc driver into the 2.6.27 queue...
> > I presume there are still some infrastructure changes in usbcore
> > that block that merge?  It'd be nice if we could merge musb_hdrc
> > without those changes (OTG related) and then update that stuff
> > separately.
> 
> Ok then, I'll prepare the patches during the next week and post
> here on l-o so people can comment.

When it's a USB patch, please post to linux-usb.  Most of the
relevant reviewers won't be on Linux-OMAP.  ;)

That said, I'm looking forward to seeing the www.beagleboard.org
hardware [1] become more generally available.  That will make some
musb_hdrc hardware available in a more developer-friendly rig than,
say, an N810 tablet.  And it might well get more folk in a position
where they can use that driver!  (I think some Blackfin devboards
are available already, but they're more pricey.)

- Dave

[1] http://www.elinux.org/BeagleBoard
