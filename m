Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZKQRIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZKQRIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZKQRIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:08:15 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58794 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbZKQRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:08:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AfOLzpGu/tq2nmg3n5mfKxtdBLaVrpq99KpdJs5TjY+IyScmWvVewaE9sL/vbT71P8
         dA9/VQqF9SxwqPUXAL6roHvPSkWe6P23onQeF0MeRPaW+YIhFntsddbhiJ/M2foZcRuv
         V9IfL3abdmCmOpfSBAwkz0ftA27/MQx4lfJa0=
Message-ID: <4B02D879.4010403@panasas.com>
Date: Tue, 17 Nov 2009 19:08:09 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 17 (exofs)
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au> <20091117090248.bb66c230.rdunlap@xenotime.net>
In-Reply-To: <20091117090248.bb66c230.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 07:02 PM, Randy Dunlap wrote:
> On Tue, 17 Nov 2009 19:53:09 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20091116:
> 
> 
> on i386 (X86_32):
> 
> fs/built-in.o: In function `exofs_sbi_read':
> (.text+0x592964): undefined reference to `__umoddi3'
> 
> ---
> ~Randy

exofs_sbi_read is a totally simple loop thing. What does the
__umoddi3 means? Please help?

Boaz
