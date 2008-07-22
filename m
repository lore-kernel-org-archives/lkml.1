Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYGVAZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYGVAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYGVAZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:25:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYGVAZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:25:48 -0400
Subject: Re: request for comment: generic kernel interface for malware
	vendors
From: Eric Paris <eparis@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <200807212014.17296.borntraeger@de.ibm.com>
References: <1216613887.2960.18.camel@localhost.localdomain>
	 <200807212014.17296.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 20:23:39 -0400
Message-Id: <1216686219.3594.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 20:14 +0200, Christian Borntraeger wrote:
> Am Montag, 21. Juli 2008 schrieb Eric Paris:
> > First I'd like to thank Sophos who stepped up and originally wrote a lot
> > of this code.  They might not recognize it since I've gotten my hands on
> > it, but they were nice enough to get the ball rolling by giving me some
> > GPL code which addressed near every request people on the malware list
> > had.
> 
> I have not looked at the code, but if I remember correctly there was another 
> GPLed code for file access scanning. It was called dazuko. Google gave me  
> http://en.wikipedia.org/wiki/Dazuko
> 
> Maybe you can get some ideas from there as well?

Maybe ideas, but it works by disabling mandatory access controls.  No
SELinux, no AppArmor, no SMACK, no TOMOYO, and therefore a non-starter.

I certainly don't think its a good idea to take a box that I am using to
try to increase organization wide security and have to lower its
individual security properties.

-Eric

