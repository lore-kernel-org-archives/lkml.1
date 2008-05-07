Return-Path: <linux-kernel-owner+w=401wt.eu-S1764662AbYEGQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764662AbYEGQK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbYEGQKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:10:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:38821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764420AbYEGQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xHYVx0yqscQCtdPNFJc3GE7LH0GnvhqcElUGc+FzM5H9DzWpUGvponB/cyoX9MpGwHcDvf9wEIW6LzUck0UDFyTA6lvZ6KikgXLnFSh5O21646gLe4oZdwMP07f6cAiTn6wfTkYu6rHVzqvknBSRqBwHYHnBigCwyigRZuEshMo=
Message-ID: <2c0942db0805070910w6b304d3cye8848d5c03462aa2@mail.gmail.com>
Date: Wed, 7 May 2008 09:10:28 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: It's time to hack on dentry_stat?
Cc: "rae l" <crquan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080507152533.GW19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
	 <20080507145116.GV19219@parisc-linux.org>
	 <2c0942db0805070808t663eafffic5e78c9d1ba8bc68@mail.gmail.com>
	 <20080507152533.GW19219@parisc-linux.org>
X-Google-Sender-Auth: 982eac11ef732637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 8:25 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, May 07, 2008 at 08:08:09AM -0700, Ray Lee wrote:
>  > One could hardcode the output of the last three (four?) fields, yes?
>  > Slightly grotty, but if it comes with a decent memory savings...
>
>  How can it be a 'decent memory saving'?  There is exactly _one_ struct
>  dentry_stat_t in the entire kernel.  So you're talking about saving 4
>  ints, or 16 bytes.  Bet you it'd be more bytes to hardcode printing zero.

<shrug> Well, if there's one, then obviously there isn't. I'd assumed
it was a per-dentry overhead.
