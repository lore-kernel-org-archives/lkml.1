Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYEISzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYEISzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYEISzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:55:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:65114 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYEISzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lnul2tWl75dIkMfkRhbUo8YN8eLsItulGD5iENGNB2xJKSlc2XH+VIdPuUHGUhHaIjW98wJVKzWgD5IsqFK/Keld/moNcnBtIKb2LG4NZOjxHAr6v/cDU6dmN78DbcunfiT7Czmb5ZsFqtEKEeL99WRL4ie+KpuHgZnTZ09oxxs=
Message-ID: <524f69650805091155n6414815ch645fe283a6412d07@mail.gmail.com>
Date: Fri, 9 May 2008 13:55:02 -0500
From: "Steve French" <smfrench@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] cifs - cifs_find_tcp_session cleanup
In-Reply-To: <aa79d98a0805062248o3f8bc639n91f6ea89df2f6cd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501154830.235254575@gmail.com>
	 <4819e79f.0c07560a.5b13.ffff8e6c@mx.google.com>
	 <524f69650805061507h5dab8731odeadb7602e0f38e4@mail.gmail.com>
	 <aa79d98a0805062248o3f8bc639n91f6ea89df2f6cd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reviewed and checked in.

On Wed, May 7, 2008 at 12:48 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
> On Wed, May 7, 2008 at 2:07 AM, Steve French <smfrench@gmail.com> wrote:
> > This looks like it would fail in the ipv6 case - because
> >  target_ip_addr (the ipv4 address) would be null and it would exit
> >  before checking.
> >
>
> Steve, could you check an updated version, please



--
Thanks,

Steve
