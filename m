Return-Path: <linux-kernel-owner+w=401wt.eu-S1162087AbXECO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162087AbXECO42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162099AbXECO41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:56:27 -0400
Received: from mail.samba.org ([66.70.73.150]:37230 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162087AbXECO41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:56:27 -0400
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be
	a	distinct module
From: simo <idra@samba.org>
To: Gerald Carter <coffeedude.jerry@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <4639F5AD.20807@gmail.com>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
	 <1178203013.28758.29.camel@localhost.localdomain>
	 <4639F5AD.20807@gmail.com>
Content-Type: text/plain
Organization: Samba Team
Date: Thu, 03 May 2007 10:56:26 -0400
Message-Id: <1178204186.28758.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 09:46 -0500, Gerald Carter wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Simo,
> 
> > I guess DFS referrals can work cross protocol, so if you are redirected
> > from a longhorn server to a windoes 2000 or a samba server you want to
> > be able to follow the DFS referral and not return an error.
> > To do that you need to have either 1 module that support both protocols
> > or a way from one module to call the other. Just separating the 2
> > without any glue will not work (or you will have to add some userspace
> > upcall hack to make it work).
> 
> Long term I agree that CIFS and SMB2 should be in the same .ko
> But NTLM 0.12 still works for Vista and DFS referrals.
> Breaking out SMB2 initially means that it will not clutter
> the working cifs.ko code.  Remember that an SMB2 client fs is
> mostly research at this point, and not engineering.

Well, development can happen in any way Steve or any other like to do
it, but it seemed to me that the proposal was to split them long term.

I think this would be bad wrt supporting DFS referrals.

That said, it I'll shut up as kindly requested from someone that seem to
know better than Samba/CIFS developers.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer
email: idra@samba.org
http://samba.org

