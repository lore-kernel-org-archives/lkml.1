Return-Path: <linux-kernel-owner+w=401wt.eu-S1765865AbXGQIKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765865AbXGQIKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXGQIKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:10:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:58430 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbXGQIKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fu64fyGO0KBjlNFOaAnrLMhATp/9dFSEg0ZAcgKM5t1TUicGJyI2MetgJgooghFHtx7ydFaF2F21DrEgMBHfmiRi9bAfvJa1SA0+WKxXxZ9SFZqKDe0ScG+rmWBjFS3qTT5y0qQR2BxtB2h+K2SpvSY7p/UsJmlNjhpUNylz7xc=
Message-ID: <84144f020707170110x4ac04320rb2ce3695d70baac8@mail.gmail.com>
Date: Tue, 17 Jul 2007 11:10:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] um_kmalloc() remnants
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jdike@addtoit.com
In-Reply-To: <84144f020707170108v64f26bfbjb8ce4c6ba69266d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IAhoN-0001iw-Ul@ZenIV.linux.org.uk>
	 <84144f020707170108v64f26bfbjb8ce4c6ba69266d0@mail.gmail.com>
X-Google-Sender-Auth: 2ca2380c20cf8d3a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > -               pri->compiled = um_kmalloc(sizeof(struct bpf_program));
> > +               pri->compiled = kmalloc(sizeof(struct bpf_program), UM_GFP_KERNEL);

On 7/17/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> GFP_KERNEL?

Uhm, missed this: http://lkml.org/lkml/2007/6/14/374. Sorry for the noise.
