Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXDNUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXDNUXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXDNUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:23:50 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:16416 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXDNUXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mdc+JpWiln8Fi65Yo+qFtqOUlaCQv6PonhaGVBarzEZIOqNl/EpX0TjkfpYPJ0fVLnXUE61nZGdOvkbjdrBpA2+iIy/mRCMmYPbKW/GpNKPSpr0IBvJo+TJ47GXVjfXV28JWDyZ47T+CA8fdsUCWPhk/cXkl4YQ5Ydd7TevoWIo=
Message-ID: <4af2d03a0704141323qc97a822kc71f4f3fc92738b0@mail.gmail.com>
Date: Sat, 14 Apr 2007 22:23:48 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jan Yenya Kasprzak" <kas@fi.muni.cz>
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Cc: linux-kernel@vger.kernel.org, osv@javad.com
In-Reply-To: <20070414202050.GG20376@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com>
	 <3018694794025219@wsc.cz> <20070414143719.GA5203@fi.muni.cz>
	 <4af2d03a0704140952w6e2338c4g3037f4ba03e2fb1d@mail.gmail.com>
	 <20070414195543.GE20376@fi.muni.cz>
	 <4af2d03a0704141311q61931b98wb613b4ee4c580b02@mail.gmail.com>
	 <20070414202050.GG20376@fi.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
> Jiri Slaby wrote:
> : On 4/14/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
> : >~BUG: spinlock lockup on CPU#0, sshd/1671, ffffffff80557780
> : [...]
> : >the write(1, "/file/name/...", ...) call returned -EIO.
> :
> : Just a question: both with mxser_new, right?
>
>         No. One side has a multiport C168H with mxser_new, and the other

I meant both lockup and EIO error -- I guess so from this line.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
