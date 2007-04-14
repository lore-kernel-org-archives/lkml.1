Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXDNWgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXDNWgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 18:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXDNWgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 18:36:25 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:37377 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXDNWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 18:36:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g6OVyffk8m3g1mD7e0QWWOVyMLxVSu7ZWYUzNnwHBG2gJgfw/U/X3S9j6kPqwYd3C+OPY+gd1r1yM1aN4kJeM8bp9C7kv4RZRLbLVPXTc3fCPBfZHeRpBaN3sZKGvmXMF2xBMGgIkxt2J0izJHuuiSop4F6IZ9TpqA2mNq98nkk=
Message-ID: <4af2d03a0704141536s36a4a0e7uc353eec6f8d340f6@mail.gmail.com>
Date: Sun, 15 Apr 2007 00:36:24 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jan Yenya Kasprzak" <kas@fi.muni.cz>
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Cc: linux-kernel@vger.kernel.org, osv@javad.com
In-Reply-To: <20070414195543.GE20376@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com>
	 <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz>
	 <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
	 <20070414195543.GE20376@fi.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
> Jiri Slaby wrote:
> :  ioctl(fd, TIOCMIWAIT, TIOCM_CD);
[...]
>         Hmm, I have tried to run this, and got a machine lockup, and after
> a minute or so the following has been printed to the console:

Hmm, the driver got shot full of holes, there's missing schedule() in
ioctl of both drivers. I'll post a patch in the morning or during the
day.

thanks for now,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
