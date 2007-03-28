Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbXC1Hdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbXC1Hdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbXC1Hdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:33:51 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31739 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933904AbXC1Hdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:33:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=H2AUJwf+dAWqWS5gPGOzdYSuBGcnguvEUbBZ2Xc0ZPkaCIsA7EE4tBfOBhPdB/tIArQWXviL279lauwquXl5LJhABYIic8+/n5fjvn5icV9xIdDmTFxRLuiXdcRg4FSadHnVIRvm3czTFKE4o1njT9ov5AznDKJw76r1MCMOvF4=  ;
X-YMail-OSG: 7GSFKt8VM1m005H4ZNAmiHN_aAj63zmLsTd_zjFK59LXgBvxmhj7mmW3dRaHMGP1XhsGia1zBTp8FQ21m5de7vgG292C5Anb.U6dJ8ihmBiQ8UGhWqBICiP1q0Mu5A--
Message-ID: <460A1A51.3090901@yahoo.com.au>
Date: Wed, 28 Mar 2007 17:33:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Hansen <hansendc@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       menage@google.com, Andrew Morton <akpm@linux-foundation.org>,
       xemul@sw.ru
Subject: Re: controlling mmap()'d vs read/write() pages
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>	<20070306140036.4e85bd2f.akpm@linux-foundation.org>	<45F3F581.9030503@sw.ru>	<20070311045111.62d3e9f9.akpm@linux-foundation.org>	<20070312010039.GC21861@MAIL.13thfloor.at>	<1173724979.11945.103.camel@localhost.localdomain>	<20070312224129.GC21258@MAIL.13thfloor.at>	<20070312220439.677b4787.akpm@linux-foundation.org>	<1173806793.6680.44.camel@localhost.localdomain>	<20070313190931.1417c012@lxorguk.ukuu.org.uk>	<m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>	<1174062660.8184.8.camel@localhost.localdomain>	<m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>	<1174074412.8184.29.camel@localhost.localdomain>	<m1zm6ajvns.fsf@ebiederm.dsl.xmission.com>	<1174407335.26166.146.camel@localhost.localdomain>	<m13b3zmx4b.fsf@ebiederm.dsl.xmission.com>	<46036C54.6030502@yahoo.com.au>	<m1tzwc5kw6.fsf@ebiederm.dsl.xmission.com>	<4603B051.8000108@yahoo.com.au> <m1hcsc5exe.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcsc5exe.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

>>It can be done trivially without performing any IO or swap, yes.
> 
> 
> Please give me a rough sketch of how to do so.

Reading sparse files is just one I had in mind. But I'm not very
creative compared to university students doing their assignments.


> Or is this about DOS'ing the system by getting the kernel to allocate
> a large number of data structures (struct file, struct inode, or the like)?

That works too. And I don't believe hand-accounting and limiting
all these things individually as a means to limit RAM usage is sane,
when you have a much more comprehensive and relatively unintrusive
page level scheme.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
