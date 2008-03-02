Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYCBPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYCBPwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYCBPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:52:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44673 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYCBPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:52:08 -0500
Date: Sun, 2 Mar 2008 09:47:42 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bdriessen@escrypt.com, shaggy@us.ibm.com, sandeen@redhat.com,
       tchicks@us.ibm.com, trevor.highland@gmail.com
Subject: Re: [PATCH] eCryptfs: Make ecryptfs_prepare_write decrypt the page
Message-ID: <20080302154742.GE4627@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080302064452.GD4627@localhost.austin.ibm.com> <20080302080452.1e66b1a9@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302080452.1e66b1a9@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 08:04:52AM -0600, Josh Boyer wrote:
> On Sun, 2 Mar 2008 00:44:52 -0600
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > When the page is not up to date, ecryptfs_prepare_write() should be
> > acting much like ecryptfs_readpage(). This includes the painfully
> > obvious step of actually decrypting the page contents read from the
> > lower encrypted file.
> > 
> > Note that this patch resolves a bug in eCryptfs in 2.6.24 that one can
> > produce with these steps:
> 
> Should it go in -stable then?

Yes; I recommend this fix for a future 2.6.24 release.
