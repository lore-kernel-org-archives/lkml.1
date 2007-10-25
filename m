Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXJYDxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXJYDxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbXJYDxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:53:30 -0400
Received: from smtpoutm.mac.com ([17.148.16.68]:54571 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbXJYDx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:53:29 -0400
In-Reply-To: <20071024213704.GA2867@sergelap.austin.ibm.com>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr> <471F9603.9080308@simon.arlott.org.uk> <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr> <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil> <20071024213704.GA2867@sergelap.austin.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E3BA758D-AD62-4009-898A-BC223838845D@mac.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to	static interface)
Date: Wed, 24 Oct 2007 23:50:50 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 24, 2007, at 17:37:04, Serge E. Hallyn wrote:
> The scariest thing to consider is programs which don't  
> appropriately handle failure.  So I don't know, maybe the system  
> runs a remote logger to which the multiadm policy gives some extra  
> privs, but now the portac module prevents it from sending its  
> data.  And maybe, since the authors never saw this failure as  
> possible, the program happens to dump sensitive data in a public  
> readable place.  I *could* be more vague but it'd be tough :)  But  
> you get the idea.

Well, there *was* that problem with sendmail where it did not  
properly check the result of setuid() and just assumed it had  
succeeded.  So instead of running as "smtpd" it was running as  
"root".   Not a happy memory.

Cheers,
Kyle Moffett

