Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbXJYUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbXJYUUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbXJYUUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:20:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57921 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762674AbXJYUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:20:01 -0400
Date: Thu, 25 Oct 2007 22:20:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Lothian <mike@fireburn.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
Message-ID: <20071025202031.GU30533@stusta.de>
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com> <20071025185022.GP30533@stusta.de> <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com> <20071025191723.GQ30533@stusta.de> <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com> <20071025195020.GS30533@stusta.de> <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:12:45PM +0100, Michael Lothian wrote:
> > The MPENTIUM4 option does not only set -march=pentium4, it also enables
> > several other options in arch/i386/Kconfig.cpu resulting in better
> > performance.
> 
> How about an autodetect to set the right options here too using cpuid?
> 
> With a warning of course that the code produced will be specifically
> for the native cpu that it's compiled on.

If you don't know or can figure out yourself the CPU you have, you'd 
better not compile your own kernel...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

