Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0BPNOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:14:55 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:56646 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0BPNOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TyK3PFzvAnev/Xq+W69iBV/1F1ecUPLmgzP0obZInRZzP9khBSKSiLTbLFhFiWyCMr
         ZbwLPQhsj3xvKCENhCLgXljV5QvGwJ7mw4+V7wkINDv3jAzvdO569B6Z8Ma/VF+D8Roi
         HJSggz7pfsruWPd+tpYYL4MJdpHS/goswkhhA=
Date: Tue, 16 Feb 2010 21:17:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100216131722.GA4382@hack.private>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <b6fcc0a1002160423o1269996bw34c033015b1ab500@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a1002160423o1269996bw34c033015b1ab500@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 02:23:55PM +0200, Alexey Dobriyan wrote:
>On Tue, Feb 16, 2010 at 2:20 PM, Nikita V. Youshchenko <yoush@cs.msu.su> wrote:
>> Unfortunately this -EINVAL is not really useful.
>
>There is no such thing.
>Driver can spit messages with printk() though.

Right, if errno is not enough, printk() is.

You could also use other interface to debug, but printk() is the
simplest.

Thanks.
