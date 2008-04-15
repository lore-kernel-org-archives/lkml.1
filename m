Return-Path: <linux-kernel-owner+w=401wt.eu-S1763615AbYDODGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615AbYDODGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbYDODGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:06:37 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:45984 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1758961AbYDODGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:06:36 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Tue, 15 Apr 2008 13:06:23 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       orenl@cs.columbia.edu
Subject: Re: [RFC][PATCH 0/4] Object creation with a specified id
Message-ID: <20080415030623.GA8171@tull.net>
References: <20080404145129.637145000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404145129.637145000@bull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 04:51:29PM +0200, Nadia.Derbey@bull.net wrote:
>    . echo "LONG XX" > /proc/self/next_id
>      next object to be created will have an id set to XX
>    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/next_id
>      next object to be created will have its ids set to XX0, ... X<n-1>
>      This is particularly useful for processes that may have several ids if
>      they belong to nested namespaces.

How do you handle race conditions, i.e. you specify the ID for the
next object to be created, and then some other thread goes and creates
an object before your thread creates one?

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
