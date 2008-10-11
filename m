Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYJKHac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYJKHac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYJKHaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:30:25 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:40344 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYJKHaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gUhZHk1mCZ9hG1H97/nph9n4ciaY2MCsmtF80sJq1MzzEKTkckZV+eCU8UKDhyamKZ
         nyQXS/uddZ/DyQgezujdX5R3JE3FguORpbcos/zadDxVw9g9i+R55o5H5FaMfxXQRcgC
         j1xzEHF2mONA7GW5GJpGthQ3phSS6HNeGZcjk=
Message-ID: <264b990a0810110030r307829afmc8c2e1dfe6713faa@mail.gmail.com>
Date: Sat, 11 Oct 2008 14:30:21 +0700
From: "Yudha Harimantoro T" <yudha.ht@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 
Cc: davidsen@tmr.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date:	Fri, 10 Oct 2008 16:41:36 -0400
From:	Bill Davidsen


>Yudha Harimantoro T wrote:
>> Hi all,
>> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
>> 2.6.27 patch and try to build it.
>>
>> I build with `make oldconfig` and answer any question with default answer, I just press [enter].
>> I build with `make`. No error and all compiled.
>> Then I install with `make modules_install` and `make install`.
>>

> I realize that this is a low-probability thought, but did you:
> - apply the patch against 2.6.26 NOT 2.6.26.6
Yup, I've did it.
> - run make clean before applying the patch
I still need this for a pure 2.6.26? I'll try this.

>> After reboot the system I got 'kernel panic'.
>> This is the error picture :
>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
>> Is it a bugs?
>>
>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg [2.6.26.6 run well]

> I keep configs in a separate place. I would first copy a 2.6.26 tree to a new directory (cp -rl linux-2.6.26 linux2.6.27) then be sure I had a clean copy with "make distclean" (or "make mrproper") and then apply the 2.6.27 patch. Then I would copy the 2.6.26 (or maybe 2.6.26.6) config to .config, and make the oldconfig.
> None of that is magic, it just keeps me from making common mistakes, lets me start with a clean 2.6.27, etc, etc.
> You mentioned oldconfig, but not starting back with a clean 2.6.26, which made me think of this.
Hm, I `cp /boot/config .config` in new kernel tree [2.6.27] for the
config. Do I make mistakes?

> --
> Bill Davidsen <davidsen@tmr.com>


Yudha_HT
