Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYIVRYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYIVRYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYIVRXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:23:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:44856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYIVRXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x7nOzdd4e3P8+xoCxnD4n0hnULc9F9EyDQBiYxtCo8AEmZeLdC6URrhqxym6cDijHN
         jCD3RtRsJVLuRlutiCRVN57Xw0QaytibEHhTIYD7dtaqDrFnaiOwDUWbReaUPDW6FSUo
         /uBQiC1UC3XY5FAi0viRmgr+EhC2KbDbT+EJ0=
Date: Mon, 22 Sep 2008 19:23:49 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Machine Check Exception Re: NetDev! Please help!
Message-ID: <20080922172349.GA2545@ami.dom.local>
References: <48D4F85C.8090709@bigtelecom.ru> <200809202111.01256.denys@visp.net.lb> <48D67239.9040006@gmail.com> <48D7385D.40107@bigtelecom.ru> <20080922065339.GA4399@ff.dom.local> <48D76813.9000603@bigtelecom.ru> <20080922112452.GB5314@ff.dom.local> <48D79709.80400@bigtelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D79709.80400@bigtelecom.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 05:00:57PM +0400, Badalian Vyacheslav wrote:
> 
> > BTW: could you try to trigger this bug with one network card off?
> >   
> 
> 
> Shire! I stop eth1 and do "/etc/init.d/bgpd stop" (this pc not get route
> traffic anymore)....
> 
> run "emerge portage" 2 times and get:
> 
> [25492.187405] CPU 3: Machine Check Exception: 0000000000000005
> [25492.187405] MCE: The hardware reports a non fatal, correctable
> incident occurred on CPU 1.
> [25492.187405] Bank 0: b200004000000800
> [25492.187405] MCE: The hardware reports a non fatal, correctable
> incident occurred on CPU 1.
> [25492.187405] Bank 5: b200120014040400
> [25497.124884] CPU 1: Machine Check Exception: 0000000000000004
> [25497.124884] Kernel panic - not syncing: Unable to continue
> [25497.124884] Rebooting in 3 seconds..
> 
> bugtracker updated.... i can get (reproduce) error on all 10 servers at
> 2.6.26.5... I use TC and not wont test 2.6.27-rc because its have (if i
> understand) multiqueue feature that not tested...

Actually, it's quite well tested, especially by Denys, and I doubt it
will be much better in 2.6.27. BTW, maybe start eth1, stop eth0 yet?

Thanks,
Jarek P.
