Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYB1N4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYB1N4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYB1N4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:56:22 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:39251 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYB1N4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:56:21 -0500
Subject: Re: [PATCH 05/11] NFSv4: Add label recommended attribute and NFSv4
	flags
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, hch@infradead.org,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0802281247130.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-6-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281247130.27221@us.intercode.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 28 Feb 2008 08:55:54 -0500
Message-Id: <1204206954.31790.64.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 12:52 +1100, James Morris wrote:
> On Wed, 27 Feb 2008, David P. Quigley wrote:
> 
> > +#define NFS4_MAXLABELLEN	255
> 
> I remember raising this before, but I think we need to try and find a 
> better way to implement this than always allocating labels of a fixed and 
> possibly too-small size.
> 
> What about perhaps starting with a statically allocated array of say 64 
> bytes (I can't see any labels on my system larger than that), and then 
> falling back to a a dynamic allocation of up to 32k if it turns out to be 
> too small ?  i.e. large labels are a slow path and there is no practical 
> limit on label size.

Yes, that would be my preference as well - there shouldn't be any
internal limits on the label size.

-- 
Stephen Smalley
National Security Agency

