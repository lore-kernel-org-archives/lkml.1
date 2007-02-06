Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbXBFGd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbXBFGd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXBFGd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:33:29 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50378 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967AbXBFGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:33:29 -0500
Date: Tue, 6 Feb 2007 12:03:21 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070206063320.GA26462@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com> <45C7CDD7.20806@zytor.com> <20070206052514.GA15613@in.ibm.com> <45C81D5B.3050408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C81D5B.3050408@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:16:59PM -0800, H. Peter Anvin wrote:
> Vivek Goyal wrote:
> >
> >I don't know much about Gujin, but advantage here seems to be that it has
> >capability to load elf files and that's why the attempt to turn kernel 
> >binary
> >into a compressed elf image. Why don't we then simply add an ELF header to
> >bzImage and Gujin and any ELF loader including Gujin, should be able to 
> >load
> >it? (As Eric had done in one of the implementations in the past?) Why to 
> >create the new infrastructure?
> >
> 
> Well, Gujin wants additional code too.
> 
> Putting an ELF header on bzImage broke some bootloaders (GRUB, I 
> believe), so that's not going to happen again.  See the relocatable 
> bzImage thread...
> 

That time, grub was working fine but lilo had broken on one of Andrew's
machine. I could not reproduce the problem on my setup and had no clue what
was the issue. Hence got rid of ELF header from bzImage which was non-essential
stuff for relocatable kernel. But that issue should be fixable.

Thanks
Vivek
