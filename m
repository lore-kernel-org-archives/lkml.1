Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXD0KYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXD0KYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXD0KYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:24:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:43279 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbXD0KYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=e/lRAXfPPiV7yxoRS5DoguTCECziqBZGJ1sTNlQ8k5ShOxjNrQqDn05gZSTHPp3YTLdLPsHUQI+4lCszz6YOR3hyR+nDRb6bGr2f//qGO6vZCwwu4izNPniQRzfOKvx8K/+Bgv/Oc4SKKSCP3fDC0bTa6kzGkBeaA0oVQp0krI4=
Date: Fri, 27 Apr 2007 18:28:35 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
Message-ID: <20070427102835.GA11449@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Michael McConnell <soruk@eridani.co.uk>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com> <20070427010914.GA2570@localhost.localdomain> <46314E0B.1020800@zytor.com> <20070427023252.GA3797@localhost.localdomain> <m1647ijvk1.fsf@ebiederm.dsl.xmission.com> <4631873B.1000107@zytor.com> <m1tzv2ie4i.fsf@ebiederm.dsl.xmission.com> <463189D3.3070805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463189D3.3070805@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:27:47PM -0700, H. Peter Anvin wrote:
>Eric W. Biederman wrote:
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>> 
>>> A lot of that code (although, of course, not all) could be written in C,
>>> though.  I'm thinking of taking a stab at rewriting it that way.
>> 
>> Is this using the .code16gcc?  Or are you thinking of some other
>> technique.  Requiring another C compiler to build the kernel would
>> be a pain to use.
>
>.code16gcc was what I was using.  There is a GSoC project that I'm
>mentoring to get 16-bit support for gcc, that will be possible to
>eventually migrate to (for code size) if/when it gets implemented and
>gets pushed out far enough, but that's for the future.
>
>	-hpa

Thanks! I will take a look at that file.

Maybe we can rewrite them in C, use a 16-bit C compiler to generate AT&T asm code and finally push the asm code in the kernel source tree. But perhaps there is no such ideal compiler. ;)

