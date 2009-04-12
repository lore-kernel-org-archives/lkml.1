Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZDLXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZDLXH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDLXHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 19:07:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZDLXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 19:07:13 -0400
Message-ID: <49E273E0.60608@zytor.com>
Date: Sun, 12 Apr 2009 16:06:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dag Bakke <dag@bakke.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: video (VGA) object-files unconditionally built/included?
References: <49DF2DCE.5050102@bakke.com> <20090410204308.155b7d65.akpm@linux-foundation.org> <49E016EB.3000800@zytor.com> <49E08454.2060205@bakke.com> <49E1026F.3030006@zytor.com> <49E1D631.7080801@bakke.com>
In-Reply-To: <49E1D631.7080801@bakke.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dag Bakke wrote:
> 
> Probably.
> Hand-editing the video*.o-files out of the Makefile and dropping the
> call to set_video in main.c gained me 4768 bytes. Definitely less than
> 87kB, but posibly worth the effort. To me, anyway.
> 
> Sorry about the noise, thank you for replying.
> 
> For the benefit of other readers working on small kernelimages, this URL
> may prove helpful:
> http://elinux.org/Kernel_Size_Tuning_Guide
> 

For what it's worth, you're welcome to submit a patch which makes this a 
configuration option conditional on CONFIG_EMBEDDED.

	-hpa
