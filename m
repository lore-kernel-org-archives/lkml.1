Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYCJEdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYCJEdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 00:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYCJEcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 00:32:52 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:54116 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750819AbYCJEcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 00:32:52 -0400
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2008 05:32:48 +0100
MIME-Version: 1.0
Subject: Re: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D4C800.4273.B14F3D3A@Frantisek.Rysanek.post.cz>
In-reply-to: <20080309220547.GR155407@sgi.com>
References: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>, <20080309220547.GR155407@sgi.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Mar 2008 at 23:05, David Chinner wrote:
>
> Sure. the largest address space that can be used on a 32bit platform
> with 4k pages is 16TB (2^32 * 2^12 = 2^44 = 16TB). For XFS, that means
> metadata can't be placed higher in the filesystem than 16TB, and seeing
> as we only have a single address space for metadata, the filesystem is
> limited to 16TB. It could be fixed with software changes, but really
> there's no excuse for using x86 given how cheap x86_64 is now..... 
>
[...] 
> 
> Yes, switching to 64 bit machines will fix this problem as the
> address space will now hold 2^64*2^12 bytes.....
> 
wow, thanks for such a precise answer, from such an authoritative 
source :-)

Frank Rysanek

