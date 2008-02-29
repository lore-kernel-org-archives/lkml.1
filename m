Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYB2BJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYB2BJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbYB2BBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:01:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761518AbYB2BBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:01:03 -0500
Date: Thu, 28 Feb 2008 20:00:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
Message-ID: <20080229010055.GA26176@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com> <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil> <20080228234850.GA25829@infradead.org> <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil> <20080229003937.GA16343@infradead.org> <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204245167.2715.37.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 07:32:47PM -0500, Dave Quigley wrote:
> I can always go with the original hook name of get_security_xattr_name
> which turns into a security_get_security_xattr_name call which seems a
> bit ludicrous. The only other complaint that I saw from Casey besides
> the name of the function was that there could be more than one xattr. If
> we want to address that then I need another hook that says give me all
> data that the LSM deems important for this file. Which is essentially
> the same thing as taking each of the xattr names that the module will
> provide, grabbing each of them in turn, and concatenating them together.
> For SELinux this is no different than getsecurity with the selinux
> suffix. The same goes for SMACK.

What about Casey's suggestion of get_security_blob?  For any reasonable
module that just has a single xattr it's trivial and for those that
have multiple or a different storage model it might get complicated
but that's not our problem for now.
