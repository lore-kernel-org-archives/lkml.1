Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbXD0A40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbXD0A40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXD0A4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:56:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:42954 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbXD0A4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B3VqQX7Ci8XONBbf8KFa/XHVYVoim34+d1xXPP9g8A4NFXUgUB6xTtyvN2m6+QrR+1Xnyrgl5p0oe7ig/KhtY3p841zshRdbg4dZbwCHg4z5Y9pyTVEtc4LlKnDCmifolFSzV0xY53CMCym2tZWNBPl1Uk5uEMb5FV4TyDrKJ5A=
Message-ID: <768a59a70704261756x5b588ef0y3a3ac9460e437b89@mail.gmail.com>
Date: Fri, 27 Apr 2007 09:56:03 +0900
From: "l l" <happyarch@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: linux-2.6.21 and __udivid3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <768a59a70704261730hbe4a987oa54f65e85d0ceda4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
	 <20070426175526.GR3468@stusta.de>
	 <768a59a70704261730hbe4a987oa54f65e85d0ceda4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It attachs,

Here is another compilation failure.

make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC [M]  drivers/w1/w1.o
drivers/w1/w1.c: In function 'w1_slave_read_id':
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
drivers/w1/w1.c:118: error: cannot take address of bit-field 'family'
make[2]: *** [drivers/w1/w1.o] Error 1
make[1]: *** [drivers/w1] Error 2
make: *** [drivers] Error 2



> I don't, i think i have to go back to gcc-4.2.0 which was fine with
> linux-2.6.21-rc7.
> It will be same to 2.6.21.
