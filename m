Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYAHOjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYAHOjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYAHOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:39:47 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:50890 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbYAHOjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:39:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cEDFKiPz2nep8QuFUes01rQBU3eOJgpuZL6yLfiZ/aoxIhoQNmgQDl4xEjrUYPQiU/WM8eUFbj2fG0GDIgUoZHcxffn8NCLxyRKUwQI9nIO9mtUlkhxsz74GlMh/SIMyOHJyI/w1q2hIHIW2wKy4sZzt7gQ2rzMehP6DYFbBZmM=
Message-ID: <5eeb9ad90801080639h2992e9b7maec0339e4f763f65@mail.gmail.com>
Date: Tue, 8 Jan 2008 15:39:45 +0100
From: DM <dm.n9107@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 2/2] track and print last unloaded module in the oops trace
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu
In-Reply-To: <20080108062656.311cd3aa@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
	 <5eeb9ad90801080551n562b9f15o27b495495a452c22@mail.gmail.com>
	 <20080108062656.311cd3aa@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 3:26 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> >
> > Why use sprintf? If a module name contains the % character we could
> > overflow the buffer. Or is module-unloading root-only and we don't
> > care?
>
> module loading isn't just root only; the name comes from an already loaded module.
> If you can load kernel modules of your choice you own the entire kernel already anway
>

Still, strcpy seems like a better choice IMHO.

/DM
