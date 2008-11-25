Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYKYOFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYKYOFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYKYOFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:05:00 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:9439 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbYKYOE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:04:58 -0500
X-Greylist: delayed 24915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 09:04:57 EST
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1227621434.7057.33.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 14:04:37 +0000
Message-Id: <1227621877.9425.102.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=VPW9pYw8AAAA:8 a=CU4zQY2J4QwqdaZ9XPEA:9 a=6YFZG0y6uwPNmCI0uoG1XbUakEEA:4 a=FMDdsIUKT1EA:10 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 08:57 -0500, Trond Myklebust wrote:
> On Tue, 2008-11-25 at 13:38 +0000, Ian Campbell wrote:
> > > That would indicate that the server is failing to close the TCP
> > > connection when the client closes on its end.
> > > 
> > > Could you remind me what server you are using?
> > 
> > 2.6.25-2-486 which is a Debian package from backports.org, changelog
> > indicates that it contains 2.6.25.7.
> 
> Hmm... It should normally close sockets when the state changes. There
> might be a race, though...
> 
> > > Also, does 'netstat -t'
> > > show connections that are stuck in the CLOSE_WAIT state when you see the
> > > hang?
> > 
> > I'd have to wait for it to reproduce again to be 100% sure but according
> > to http://lkml.indiana.edu/hypermail/linux/kernel/0808.3/0120.html
> > I was seeing connections in FIN_WAIT2 but not CLOSE_WAIT.
> 
> That would be on the client side. I'm talking about the server.

Ah, OK. I'll abort my current test of 2.6.26+revert and wait for a repro
so I can netstat the server, give me a couple of days...

Ian.
-- 
Ian Campbell

It is more rational to sacrifice one life than six.
		-- Spock, "The Galileo Seven", stardate 2822.3

