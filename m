Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbZDBMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbZDBMN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZDBMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:13:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:5860 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbZDBMNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ITAS8CeHlcgY4/2Mt/yVDFG7IWeKy0lJRgZuMgvvHEmfQs08AcPuJX5Js43qHT0aFP
         lnvfpO4hLBFdMulgQPdHhbP/cTFr1b7s98T3uYOZ8sm7aBAalyju1+MSRfRbnExLOjvU
         tEjjpLPGtSNxUBDQm5Ss8NqoJ5usO3AW/YD94=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <49D3EDEA.4090803@zytor.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 14:13:26 +0200
Message-Id: <1238674406.13249.24.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 15:42 -0700, H. Peter Anvin wrote:
> I think if the cost is 40 ms once during boot on a slow platform, it's 
> worth unifying the two codebases.  I am *not* saying that I don't think 
> boot performance matters -- far be from it -- but I think this is 
> probably worth the reliability and maintainability advantages of having 
> a single piece of code if at all possible.
> 
> Of course, if you can figure out how to avoid that and still have the 
> code clean, then that's another matter.

Alrighty. I will merge the two functions and if that turns out ugly, go
with the safe one, and submit a new patchset. I'll be right back. :)

Cheers,
Andreas

