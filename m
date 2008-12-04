Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYLDSpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYLDSpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYLDSpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:45:24 -0500
Received: from mail.fieldses.org ([66.93.2.214]:37681 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbYLDSpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:45:23 -0500
Date: Thu, 4 Dec 2008 13:45:22 -0500
To: Russell Miller <duskglow@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nfs NULL procedure packets
Message-ID: <20081204184522.GA7575@fieldses.org>
References: <4eea36270812031011x5f014b04q352af666cacb2f93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eea36270812031011x5f014b04q352af666cacb2f93@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 10:11:26AM -0800, Russell Miller wrote:
> Hi again, I was hoping someone here could answer another question.  I
> apologize if these are easy questions...
> 
> So a couple of days ago I was troubleshooting yet another NFS problem
> (not the non-one I described a few days ago).  I sent a 1G file over
> to a server, did a TCP capture, and analyzed the results.
> 
> I noticed a lot of NULL procedure packets.  A *lot* of them.  In some
> cases, one every 10 microseconds, and there were about 400,000 of them
> I captured.
> 
> This seems like a lot of network traffic for very little reason.
> 
> Is this normal behavior, or something I should investigate further?
> It seems to me like pinging the NFS server once every 10 microseconds
> is a major waste of bandwidth.

It's either a bug, or you're misreading the traces--how are you
identifying these as NULL procedures?  Also, are they NULL NFS calls, or
some other rpc protocol?  And are you using krb5?

--b.
