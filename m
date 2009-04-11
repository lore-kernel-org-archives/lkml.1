Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZDKUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZDKUur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZDKUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:50:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbZDKUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:50:37 -0400
Message-ID: <49E1026F.3030006@zytor.com>
Date: Sat, 11 Apr 2009 13:49:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dag Bakke <dag@bakke.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: video (VGA) object-files unconditionally built/included?
References: <49DF2DCE.5050102@bakke.com> <20090410204308.155b7d65.akpm@linux-foundation.org> <49E016EB.3000800@zytor.com> <49E08454.2060205@bakke.com>
In-Reply-To: <49E08454.2060205@bakke.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dag Bakke wrote:
> 
> So the videobits appear to be built and added on to the kernel image
> after the main chunk gets compressed. And the size of the video*.o
> objects sums up to 87k.
> 
> If my reasoning is too stupid for words, would you mind providing a
> graphical illustration of my stupidity?  :-)
> 

It's not our job to do yours for you.

*.o files contain a LOT of metadata.  The "size" command tells you the
real size.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

