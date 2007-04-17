Return-Path: <linux-kernel-owner+w=401wt.eu-S1161257AbXDQRrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbXDQRrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161263AbXDQRrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:47:45 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:38699 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161258AbXDQRro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:47:44 -0400
Date: Tue, 17 Apr 2007 13:47:39 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andi Kleen <andi@firstfloor.org>
cc: Karl MacMillan <kmacmill@redhat.com>,
       David Safford <safford@watson.ibm.com>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <p73abx66fme.fsf@bingen.suse.de>
Message-ID: <Line.LNX.4.64.0704171323090.19432@d.namei>
References: <20070416213350.GB4030@suse.de> <Line.LNX.4.64.0704161846110.13905@d.namei>
 <1176822230.3366.65.camel@localhost.localdomain> <1176825641.5946.41.camel@localhost.localdomain>
 <p73abx66fme.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Andi Kleen wrote:

> You nicely show one of the major disadvantages of the label model vs the path 
> model here: it requires modification of a lot of applications. 

This is incorrect.

Normal applications need zero modification under SELinux.

Some applications which manage security may need to be made SELinux-aware, 
although this can often be done with PAM plugins, which is a standard way 
to do this kind of thing in modern Unix & Linux OSs.

In any case, it has never been unusual for security-critical Unix/Linux 
apps to be aware of extra security frameworks, and conditionally utilize 
things like kerberos, tcpwrappers, SSL, skey etc.

Also, there's nothing inherent in pathname labeling vs. object labeling 
which makes one model require modification of applications more than the 
other.  You're taking one implementation of each and extrapolating to the 
general case, without even taking into consideration that the 
modifications only refer to security-management functions.

Also, in terms of implementation, these security schemes are quite 
different in their coverage and features, so it's an apples vs. oranges 
comparison anyway.


Thanks,



- James
-- 
James Morris
<jmorris@namei.org>
