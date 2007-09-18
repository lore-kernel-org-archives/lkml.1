Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbXIRUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbXIRUKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbXIRUKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:10:37 -0400
Received: from pool-71-118-246-34.lsanca.dsl-w.verizon.net ([71.118.246.34]:42687
	"EHLO www.thewybles.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbXIRUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:10:36 -0400
Message-ID: <46F030DD.7080201@thewybles.com>
Date: Tue, 18 Sep 2007 13:11:09 -0700
From: Charles N Wyble <charles@thewybles.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support	under	Virtualization
 menu
References: <1189747054.7262.34.camel@localhost.localdomain>	<1189747124.7262.36.camel@localhost.localdomain>	<20070914091921.73007c5a.randy.dunlap@oracle.com>	<1189825504.7262.75.camel@localhost.localdomain>	<7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>	<1189928617.7262.98.camel@localhost.localdomain>	<46ED440E.3020209@goop.org> <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com> <46EF0E0A.2000804@thewybles.com> <46EF1952.3010604@goop.org>
In-Reply-To: <46EF1952.3010604@goop.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Jeremy Fitzhardinge wrote:
> Charles N Wyble wrote:
>>
>> Zachary Amsden wrote:
>> <snip>>
>>> Virtualization is completely different, and probably needs separate
>>> server (kvm, lguest) and client (kvm, lguest, xen, vmware) sections in
>>> it's menu.
>>
>> So what is the differentiation between client and server above? Just
>> curious what makes kvm and lguest server and client.
> 
> "Host" and "guest" are better terms, I think.  Kvm is all host, since
> guests need no modification.  lguest turns the kernel into both host and
> guest.  Xen Linux kernels are all guest, since the Xen hypervisor is the
> host.
> 
>     J


Ah ok. Thank you so much for the clarification. :)
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD4DBQFG8DDdkQPZV56XDBMRAl6NAJ90z7tRO+xAvbOOkKeKH6LZWGjNSACYms3u
dqGGgl1GOFraS08UmEf++A==
=HgFC
-----END PGP SIGNATURE-----
