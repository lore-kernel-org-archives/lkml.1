Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZBQVFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZBQVFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZBQVFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:05:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZBQVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:05:27 -0500
Message-ID: <499B267E.2090509@zytor.com>
Date: Tue, 17 Feb 2009 13:05:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Monday 2009-01-05 00:58, H. Peter Anvin wrote:
>> I have pulled the x86 parts of the bzip2/lzma patchset into
>> tip:x86/setup-lzma.  I would appreciate it if you could look at it and
>> make sure it looks sane.  I have not added the ARM portions (patch 4),
>> since those should go via the ARM tree, nor the capstone patch 5, which
>> can only be added after the old code is removed from *all* remaining
>> architectures.
> 
> It seems to work well here. It would be cool if this finds its way
> into mainline sometime.

There were some build failures with "make randconfig" I seem to recall. 
  Those need to be addressed soon if we're going to be able to push this 
for .30.

	-hpa

