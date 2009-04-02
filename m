Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZDBOe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZDBOe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZDBOep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:34:45 -0400
Received: from lucius.provo.novell.com ([137.65.248.127]:39317 "EHLO
	lucius.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbZDBOeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:34:44 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 10:34:44 EDT
Message-Id: <49D473EA020000C700056627@lucius.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 02 Apr 2009 08:14:34 -0600
From: "Patrick Mullaney" <pmullaney@novell.com>
To: <avi@redhat.com>
Cc: <anthony@codemonkey.ws>, <andi@firstfloor.org>,
       <herbert@gondor.apana.org.au>, "Gregory Haskins" <GHaskins@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>, <rusty@rustcorp.com.au>,
       <agraf@suse.de>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <49D469D2020000A100045FA1@lucius.provo.novell.com>
 <49D473EA020000C700056627@lucius.provo.novell.com>
In-Reply-To: <49D473EA020000C700056627@lucius.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 16:27 +0300, Avi Kivity wrote:

> 
> virtio is a stable ABI.
> 
> > However, theres still the possibility we can make this work in an ABI
> > friendly way with cap-bits, or other such features.  For instance, the
> > virtio-net driver could register both with pci and vbus-proxy and
> > instantiate a device with a slightly different ops structure for each or
> > something.  Alternatively we could write a host-side shim to expose vbus
> > devices as pci devices or something like that.
> >   
> 
> Sounds complicated...
> 

IMO, it doesn't sound anymore complicated than making virtio support the
concepts already provided by vbus/venet-tap driver. Isn't there already
precedent for alternative approaches co-existing and having the users
decide which is the most appropriate for their use case? Switching
drivers in order to improve latency for a certain class of applications
would seem like something latency sensitive users would be more than
willing to do. I'd like to point out 2 things. Greg has offered help
in moving virtio into the vbus infrastructure. The vbus infrastructure
is a large part of what is being proposed here.


