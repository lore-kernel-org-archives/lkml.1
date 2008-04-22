Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYDVUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYDVUr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760998AbYDVUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:46:59 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:60724 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760342AbYDVUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ma1BCBXy6c1yEXAF0ijWdZU5Eot0m+bRBKQMX5XtQWIxPkLNimEMmnkH1Djt5cL5DDDFSJHse80HrExYs/phMY55wd9EZUPuIqu6Cug1jVIC6KVZR9hWcvOhX3fteiRz4foyR5KGmSyap6bkgXDdK1oF11S1cPLWw6SbH6elGRo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: #define out unused parameters =?utf-8?q?of=09xfs=5Fbmap=5Fadd=5Ffree_and?= xfs_btree_read_bufl
Date: Tue, 22 Apr 2008 22:46:16 +0200
User-Agent: KMail/1.8.2
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080419142329.GA5339@elte.hu> <20080422172156.GB28933@cs181133002.pp.htv.fi> <480E1FAE.20509@sandeen.net>
In-Reply-To: <480E1FAE.20509@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804222246.16980.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 19:26, Eric Sandeen wrote:
> It would be a huge undertaking.
> 
> Just building xfs w/ the warning in place exposes tons of unused
> parameter warnings from outside xfs as well.

I was grepping them away.

> But, if it was deemed important enough, you could go annotate them as
> unused, I suppose, and hack away at it...  Does marking as unused just
> shut up the warning or does it let gcc do further optimizations?

It just shuts up the warning. It is still useful - suppresses
false positives.

I didn't check whether gcc is clever enough to reuse stack space
occupied by unused parameter(s) as a free space for automatic
variables. In theory it is allowed to do that and reduce stack usage
that way.
--
vda
