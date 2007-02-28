Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXB1Js5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXB1Js5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbXB1Js5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:48:57 -0500
Received: from mx10.go2.pl ([193.17.41.74]:53462 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932107AbXB1Js4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:48:56 -0500
Date: Wed, 28 Feb 2007 10:52:35 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: jt@hpl.hp.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "David S\. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
Message-ID: <20070228095234.GB1847@ff.dom.local>
References: <20070228012741.GA3988@bougret.hpl.hp.com> <20070228093437.GA1847@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228093437.GA1847@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 10:34:37AM +0100, Jarek Poplawski wrote:
> On 28-02-2007 02:27, Jean Tourrilhes wrote:
...
> > +	/* This function is only used for network interface.
> > +	 * Some hotplug package track interfaces by their name and
> > +	 * therefore want to know when the name is changed by the user. */
> > +	if(!error)
> > +		kobject_uevent_env(&class_dev->kobj, KOBJ_RENAME, envp);
> > +
> >  	class_device_put(class_dev);
> >  
> > +	kfree(devname_string);
> 
> Maybe I miss something, but it seems kobject_uevent_env copies
> pointers from envp instead of buffers' contents.

And it's enough - sorry.

Jarek P.
