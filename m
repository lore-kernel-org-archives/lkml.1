Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYAJVZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYAJVZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYAJVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:25:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33411 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYAJVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:25:35 -0500
Message-ID: <47868D4B.6030608@garzik.org>
Date: Thu, 10 Jan 2008 16:25:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: NFSv4: Give the lock stateid its own sequence queue
References: <1199999274.13775.16.camel@heimdal.trondhjem.org>
In-Reply-To: <1199999274.13775.16.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> Sharing the open sequence queue causes a deadlock when we try to take both
> a lock sequence id and and open sequence id.
> 
> This fixes the regression reported by Dimitri Puzin and Jeff Garzik:
> See http://bugzilla.kernel.org/show_bug.cgi?id=9712
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Tested-by: Jeff Garzik <jgarzik@redhat.com>


