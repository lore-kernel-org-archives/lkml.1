Return-Path: <linux-kernel-owner+w=401wt.eu-S1031402AbXEDRnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031402AbXEDRnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031413AbXEDRnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:43:16 -0400
Received: from mail.samba.org ([66.70.73.150]:56209 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031402AbXEDRnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:43:15 -0400
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be
	a	distinct module
From: simo <idra@samba.org>
To: Jeremy Allison <jra@samba.org>
Cc: Gerald Carter <coffeedude.jerry@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070504171200.GE31976@samba1>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
	 <1178203013.28758.29.camel@localhost.localdomain>
	 <4639F5AD.20807@gmail.com>  <20070504171200.GE31976@samba1>
Content-Type: text/plain
Organization: Samba Team
Date: Fri, 04 May 2007 17:43:13 +0000
Message-Id: <1178300593.28758.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 10:12 -0700, Jeremy Allison wrote:

> Actually I disagree. I think Christoph is correct. These
> are two independent protocols and should be in two different
> modules.

They are independent the same way NFS v4 is independent from NFS v3 and
v2. Independent but related, and most importantly, one is the fallback
of the other.

> > But NTLM 0.12 still works for Vista and DFS referrals.
> > Breaking out SMB2 initially means that it will not clutter
> > the working cifs.ko code.  Remember that an SMB2 client fs is
> > mostly research at this point, and not engineering.
> 
> Long term the common functions should be factored out
> and put into a lower-level module that both cifs and
> SMB2 are dependent upon.
> 
> That's the cleaner solution IMHO.

If the result is that the fallback work without user space intervention,
then I agree with you.
I was just pointing out that the 2 protocols are not in fact completely
independent and this fact need to be properly considered and factored in
into this decision, nothing more, nothing less.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer
email: idra@samba.org
http://samba.org

