Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXFOQkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXFOQkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXFOQkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:40:31 -0400
Received: from gw.goop.org ([64.81.55.164]:56341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXFOQka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:40:30 -0400
Message-ID: <4672C0FF.9080209@goop.org>
Date: Fri, 15 Jun 2007 09:40:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 03/10] define ELF notes for adding to a boot image
References: <20070615004818.424726597@goop.org> <20070615005012.882738673@goop.org> <4672BC5B.1040502@zytor.com>
In-Reply-To: <4672BC5B.1040502@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> +#define EIN_PROGRAM_CHECKSUM	3 /* ip style checksum of the memory image. */
>>     
>
> Why on earth use one of the weakest verificants in common use?

I don't know.  I copied this stuff from the original relocatable kernel
patches; I think this is from Vivek.  Eric, Vivek: is there a specific
use for these notes?

    J
