Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYLCWUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYLCWUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYLCWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:20:06 -0500
Received: from mail.somanetworks.com ([216.126.67.42]:42792 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYLCWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:20:04 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 17:20:04 EST
Date: Wed, 3 Dec 2008 17:15:11 -0500 (EST)
From: Scott Murray <scottm@somanetworks.com>
X-X-Sender: scottm@rancor
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch 034/104] PCI: cpci_hotplug: stop managing
 hotplug_slot->name
In-Reply-To: <20081203195057.GI8950@kroah.com>
Message-ID: <alpine.LFD.1.10.0812031711160.6809@rancor>
References: <20081203193901.715896543@mini.kroah.org> <20081203195057.GI8950@kroah.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Greg KH wrote:

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
> From: Alex Chiang <achiang@hp.com>
>
> commit d6c479e0b777afcd7a26ca62e122e3f878ccc830 upstream.
>
> We no longer need to manage our version of hotplug_slot->name
> since the PCI and hotplug core manage it on our behalf.
>
> Now, we simply advise the PCI core of the name that we would
> like, and let the core take care of the rest.
>
> Cc: kristen.c.accardi@intel.com
> Cc: scottm@somanetworks.com
> Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Scott Murray <scottm@somanetworks.com>

Sorry for the extremely late review, I had been swamped and am now in the
process of switching jobs.  scottm@somanetworks.com will stop working
soon, I will submit a patch shortly to change it in MAINTAINERS.

Scott


-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com
