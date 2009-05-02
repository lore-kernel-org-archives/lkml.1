Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZEBSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZEBSf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZEBSfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:35:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47737 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEBSfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TQF4f5QiVUADtcYG6wKnyU8xUL1qGwaU1DYwjbCv6S11WAYsqcdi/nF+x6GEYCFBZF
         N+Oejy3v4oJj0iWb1tlAjwGvdGB3hGDWhNYVZ8rE3TzsmkNlP+drOXfELVPG2tpwGSdh
         ilXbs75yaXRf3+Bb7V0f6cYEgVrGUTR1yjGPE=
MIME-Version: 1.0
In-Reply-To: <20090502101405.GA6145@fancy-poultry.org>
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	 <20090502101405.GA6145@fancy-poultry.org>
Date: Sat, 2 May 2009 22:35:17 +0400
Message-ID: <a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, Heinz Diehl <htd@fancy-poultry.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/2 Heinz Diehl <htd@fancy-poultry.org>:
> On 01.05.2009, Alexander Beregalov wrote:
>
>> # xfs_db -r /dev/sdc1
>> xfs_db> frag
>> actual 23805, ideal 22890, fragmentation factor 3.84%
>> # xfs_fsr -v /dev/sdc1
>> /mnt/c start inode=0
>> ino=158
>> extents before:3 after:1 DONE ino=158
>>
>>  then it hangs
>
> I can't confirm this here on my systems:
>
> liesel:~ # uname -a
> Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

I have this problem on two x86_32 hosts.
It runs for about a minute and then hangs.
vmstat 1:
 0  1     80  30856  12284 1289452    0    0 16384 16380  224  301  0  5  0 95
 0  1     80  32020  12196 1287884    0    0 25984 16380  290  470  0 11  0 89
 0  1     80  30732  12132 1289648    0    0 23168 32760  286  413  0  6  0 94
 0  1     80  32220  12128 1287620    0    0 16384 16380  220  303  0  8  0 92
 1  0     80 198312  12108 1137956    0    0 14472 14628  223  284  0 10  3 87
 0  0     80 1118144  12108 218216    0    0     0     0   63   33  0 38 62  0
 0  0     80 1118144  12108 218216    0    0     0     0   24   26  0  0 100  0
 0  0     80 1118144  12108 218216    0    0     0     0   36   28  0  1 99  0
 0  0     80 1118144  12108 218216    0    0     0     0   36   32  1  1 98  0
 0  0     80 1118144  12108 218216    0    0     0     0   78   66  0  1 99  0
