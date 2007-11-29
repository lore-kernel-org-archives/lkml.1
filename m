Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbXK2SDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbXK2SDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbXK2SDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:03:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:24220 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbXK2SDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q9E5Sm+M1wK0LwaiZ3jau64uOuJs7t/S6YqOQu4I302YjJQdCtMQqJHTtSW+hCNbJ7IHQHOqqQSlxy9ydyf3wEXr7/69gzvr50QZBm5NaScnAETRvy5DoTf5kh2JrQPldH05rrywObAJzaOGFqDGjbzqWN+PTNk0Bwk1sRgknik=
Message-ID: <2c0942db0711291003h45177f3cr5496cf30bdb01996@mail.gmail.com>
Date: Thu, 29 Nov 2007 10:03:09 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Out of tree module using LSM
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Jon Masters" <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071129174528.GA14431@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25290.1196273705@turing-police.cc.vt.edu>
	 <20071129003840.GA22530@kroah.com>
	 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	 <20071129010753.GA19106@kroah.com>
	 <1196354172.6473.52.camel@perihelion>
	 <20071129164746.GB9664@kroah.com>
	 <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
	 <20071129170326.GA10024@kroah.com>
	 <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
	 <20071129174528.GA14431@kroah.com>
X-Google-Sender-Auth: 677ae7423a8bdbb5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 9:45 AM, Greg KH <greg@kroah.com> wrote:
> > Perhaps if you looked at this outside of a file-server scenario, the
> > problem would be clearer? Anti-malware companies want to check
> > anything written to disk on a system, either at write time or blocking
> > the open/mmap. That means proactively protecting email programs with
> > known vulnerabilities that have yet to be patched, web browsers
> > writing and reading their caches, an Apache instance running WebDAV,
> > the list goes on. And these are on desktop systems, with no attached
> > file/network server.
>
> Ok, if they want to check on every open/mmap then just hook in glibc to
> do this.  Especially as they want to run userspace code at this point in
> time.

Doesn't help statically linked binaries, or anything else that bypases glibc.

But yes, I'll let them argue their point from here.
