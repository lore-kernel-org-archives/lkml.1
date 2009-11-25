Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbZKYOG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbZKYOG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934668AbZKYOG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:06:26 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:33296 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508AbZKYOGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CfG7k3VCRzNB5hdyF5PpDL9UDCJEf4VWqyN1iJRKSreylCKu78TAZYvV+oETJGwBAw
         7KspwJkTcOcCXmghqjLfhvLh36CUOnZmvIvq7c5yM14oWtfeE3Evg9ydNAsUwX8eWCJb
         UCJMe4Yp9kir6iahAntrqtEBaRs9te+GN5doc=
MIME-Version: 1.0
In-Reply-To: <20091124111946.GA7883@ff.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
	 <20091124111946.GA7883@ff.dom.local>
Date: Wed, 25 Nov 2009 09:06:30 -0500
Message-ID: <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alas it's not all information I asked. E.g. "netstat -s before faulty
> kernel" and "netstat -s after faulty kernel" seem to be the same file:
> netstat_after.slave4.log.gz.

sorry I guess I misunderstood what you wanted? (or maybe I just dorked
it when I created all the files)  I upped a netstat -s from a good
kernel shortly after reboot.

> Anyway, since there are problems with
> getting stats from the router we still can't compare them, or check
> for the dropped stats. (Btw, could you check for /proc/net/softnet_stat
> yet?)

router? good kernel? bad kernel?

> So, it might be the kernel problem you reported, but there is not
> enough data to prove it. Then my proposal is to try to repeat this
> problem in more "testing friendly" conditions - preferably against
> some other, more up-to-date linux box, if possible?

yeah 2.6.31.6 works on my laptop fine I'll just have to see about
getting a direct connection to it. probably do that after I bring the
other NIC back from home, on thanksgiving.


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
