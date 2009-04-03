Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZDCEnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZDCEnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbZDCEnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:43:40 -0400
Received: from gw.goop.org ([64.81.55.164]:38818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZDCEnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:43:40 -0400
Message-ID: <49D593F8.3030006@goop.org>
Date: Thu, 02 Apr 2009 21:43:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D487A6.407@redhat.com> <49D49C1F.6030306@novell.com> <200904022243.21088.rusty@rustcorp.com.au> <20090402151020.GB1986@dhcp-1-124.tlv.redhat.com>
In-Reply-To: <20090402151020.GB1986@dhcp-1-124.tlv.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> Rusty, I think this is what you did in your patch from 2008 to add destructor
> for skb data ( http://kerneltrap.org/mailarchive/linux-netdev/2008/4/18/1464944 ):
> and it seems that it would make zero-copy possible - or was there some problem with
> that approach? Do you happen to remember?
>   

I'm planning on resurrecting it to replace the page destructor used by 
Xen netback.

    J

