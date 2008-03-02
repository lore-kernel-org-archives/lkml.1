Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYCBOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYCBOHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 09:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYCBOHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 09:07:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:63681 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYCBOHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 09:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=k7jfFumQGUEknUCdBa0Btf3FmoUL5Uv2Eae/x6Kj/RgfFg8vfRKZAdCrAwJLm67p4WjM0JYhVAgYbKkMj/1M8q3GeBm+0r9ZRofwahCS57dQgKjTc1eV32Ph1P7c08eUyOA6NAv8lnDHRdLs4R+05RnaOWNXxJ71C1bbAZWhMgQ=
Date: Sun, 2 Mar 2008 08:04:52 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bdriessen@escrypt.com, shaggy@us.ibm.com, sandeen@redhat.com,
       tchicks@us.ibm.com, trevor.highland@gmail.com
Subject: Re: [PATCH] eCryptfs: Make ecryptfs_prepare_write decrypt the page
Message-ID: <20080302080452.1e66b1a9@zod.rchland.ibm.com>
In-Reply-To: <20080302064452.GD4627@localhost.austin.ibm.com>
References: <20080302064452.GD4627@localhost.austin.ibm.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 00:44:52 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> When the page is not up to date, ecryptfs_prepare_write() should be
> acting much like ecryptfs_readpage(). This includes the painfully
> obvious step of actually decrypting the page contents read from the
> lower encrypted file.
> 
> Note that this patch resolves a bug in eCryptfs in 2.6.24 that one can
> produce with these steps:

Should it go in -stable then?

josh
