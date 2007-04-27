Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbXD0F14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbXD0F14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXD0F14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:27:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbXD0F1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:27:55 -0400
Message-ID: <463189D3.3070805@zytor.com>
Date: Thu, 26 Apr 2007 22:27:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com>	<20070427010914.GA2570@localhost.localdomain>	<46314E0B.1020800@zytor.com>	<20070427023252.GA3797@localhost.localdomain>	<m1647ijvk1.fsf@ebiederm.dsl.xmission.com>	<4631873B.1000107@zytor.com> <m1tzv2ie4i.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzv2ie4i.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> A lot of that code (although, of course, not all) could be written in C,
>> though.  I'm thinking of taking a stab at rewriting it that way.
> 
> Is this using the .code16gcc?  Or are you thinking of some other
> technique.  Requiring another C compiler to build the kernel would
> be a pain to use.

.code16gcc was what I was using.  There is a GSoC project that I'm
mentoring to get 16-bit support for gcc, that will be possible to
eventually migrate to (for code size) if/when it gets implemented and
gets pushed out far enough, but that's for the future.

	-hpa
