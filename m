Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbZJTCaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbZJTCaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZJTCaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:30:00 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:38833 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbZJTC37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:29:59 -0400
Subject: Re: nfs oops in 2.6.32-rc5-00041-g1d91624
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: Egon Alter <egon.alter@gmx.net>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <1255997511.2892.8.camel@heimdal.trondhjem.org>
References: <200910191803.26845.egon.alter@gmx.net>
	 <200910200151.55016.elendil@planet.nl>
	 <1255997511.2892.8.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 11:29:58 +0900
Message-Id: <1256005799.10198.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 9 sum msgs/h 1 total rcpts 1709 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8123970272AEE28F512BD10FB4D7B8DC7C812895
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 6 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 09:11 +0900, Trond Myklebust wrote:

> Hmm...It looks as though the credential doesn't have a crvalidate
> method. I'll see if I can track this down...

BTW: What security flavour are you using (please see
'cat /proc/self/mountinfo' on the client and /etc/exports on the
server).

Cheers
  Trond

