Return-Path: <linux-kernel-owner+w=401wt.eu-S965361AbXBFGRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361AbXBFGRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 01:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965362AbXBFGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 01:17:12 -0500
Received: from terminus.zytor.com ([192.83.249.54]:46234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965361AbXBFGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 01:17:12 -0500
Message-ID: <45C81D5B.3050408@zytor.com>
Date: Mon, 05 Feb 2007 22:16:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin
 1/3
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com> <45C7CDD7.20806@zytor.com> <20070206052514.GA15613@in.ibm.com>
In-Reply-To: <20070206052514.GA15613@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> 
> I don't know much about Gujin, but advantage here seems to be that it has
> capability to load elf files and that's why the attempt to turn kernel binary
> into a compressed elf image. Why don't we then simply add an ELF header to
> bzImage and Gujin and any ELF loader including Gujin, should be able to load
> it? (As Eric had done in one of the implementations in the past?) Why to 
> create the new infrastructure?
> 

Well, Gujin wants additional code too.

Putting an ELF header on bzImage broke some bootloaders (GRUB, I 
believe), so that's not going to happen again.  See the relocatable 
bzImage thread...

	-hpa

