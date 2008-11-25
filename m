Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYKYN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYKYN5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKYN5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:57:21 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:60095 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYKYN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:57:20 -0500
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
 120 seconds"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1227620339.9425.99.camel@zakaz.uk.xensource.com>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 08:57:14 -0500
Message-Id: <1227621434.7057.33.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E9EC359DD8EEA4707FAA323C8F6547B82CFD9F1B
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 218 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 13:38 +0000, Ian Campbell wrote:
> > That would indicate that the server is failing to close the TCP
> > connection when the client closes on its end.
> > 
> > Could you remind me what server you are using?
> 
> 2.6.25-2-486 which is a Debian package from backports.org, changelog
> indicates that it contains 2.6.25.7.

Hmm... It should normally close sockets when the state changes. There
might be a race, though...

> > Also, does 'netstat -t'
> > show connections that are stuck in the CLOSE_WAIT state when you see the
> > hang?
> 
> I'd have to wait for it to reproduce again to be 100% sure but according
> to http://lkml.indiana.edu/hypermail/linux/kernel/0808.3/0120.html
> I was seeing connections in FIN_WAIT2 but not CLOSE_WAIT.

That would be on the client side. I'm talking about the server.

Cheers
  Trond

