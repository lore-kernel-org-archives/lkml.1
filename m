Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYB2CQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYB2CQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYB2CPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:15:53 -0500
Received: from namei.org ([69.55.235.186]:41242 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753368AbYB2CPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:15:52 -0500
Date: Fri, 29 Feb 2008 13:15:16 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Dave Quigley <dpquigl@tycho.nsa.gov>,
       Christoph Hellwig <hch@infradead.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
In-Reply-To: <519499.69572.qm@web36614.mail.mud.yahoo.com>
Message-ID: <Xine.LNX.4.64.0802291306141.9062@us.intercode.com.au>
References: <519499.69572.qm@web36614.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Casey Schaufler wrote:

> Easier may be pragmatic, but that does not make it right.
> I suggest, that in my opinion (there, is that sufficiently
> non-confrontational?) that Linux and the LSM are much better
> served by a general xattr protocol than by adding a single
> reccommended attribute.

An xattr protocol is overkill for conveying a MAC label over the network, 
and would still not provide the required semantics.

Please see prior discussion on this e.g.

http://marc.info/?l=linux-kernel&m=120424789929258&w=2

Note that RAs are already used to convey ACLs and all other system-managed 
metatdata.  i.e. an extensible, appropriate infrastructure already exists 
in the NFSv4 protocol, and has been used successfully for similar 
purposes.  We do not need to add a new, generalized protocol to NFSv4 
for this, especially one which does not meet the requirements.




- James
-- 
James Morris
<jmorris@namei.org>
