Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZKJV6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZKJV6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbZKJV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:58:13 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:49460 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbZKJV6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:58:12 -0500
Subject: Re: sunrpc port allocation and IANA reserved list
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1257887844.3044.24.camel@heimdal.trondhjem.org>
References: <4AF9A63B.6010101@nortel.com>
	 <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
	 <4AF9B2CF.6050305@nortel.com>
	 <1257884799.3044.7.camel@heimdal.trondhjem.org>
	 <4AF9D5D1.9040501@nortel.com>
	 <1257887844.3044.24.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 06:58:10 +0900
Message-Id: <1257890290.3044.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 10 sum msgs/h 3 total rcpts 1838 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 486C94379D6912BEC765B373BED98F1714B72CA8
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 37 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 06:17 +0900, Trond Myklebust wrote:
> The people who are trying to run absolutely all IANA registered services
> on a single Linux machine that is also trying to run as an NFS client
> may have a problem, but then again, how many setups do you know who are
> trying to do that?

BTW: Even these setups can be fixed. One way to extend the available
port ranges is to allocate more than one IP address; either through the
use of multiple NICs, or through address aliasing. You can set up the
services to listen on one interface, while setting up your routing
tables to ensure that any outgoing connections to your NFS servers go
through through a different interface.

You could also use virtualised machines to host the services, etc...

Trond

