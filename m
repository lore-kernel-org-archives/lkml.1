Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYGRGhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYGRGhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYGRGh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:37:28 -0400
Received: from isilmar.linta.de ([213.133.102.198]:59997 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752081AbYGRGh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:37:27 -0400
Date: Fri, 18 Jul 2008 08:37:25 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Greg KH <greg@kroah.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080718063725.GA26585@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Greg KH <greg@kroah.com>, Jason Baron <jbaron@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080717225611.GA27481@isilmar.linta.de> <20080717233524.GA28711@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717233524.GA28711@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 04:35:24PM -0700, Greg KH wrote:
> > 	<sysfs>/module/<module_name>/debug/{enabled[,level][,flag]}
> 
> I like this as that is what a number of current modules do (usb-serial
> drivers), but you have to be careful about the module parameter
> namespace to not get collisions here with existing "debug" files.

That's why I'd put it into a different namespace (debug instead of
parameters).

> So for now, I recommend staying in debugfs, it makes more sense.

ACK.

Best,
	Dominik
