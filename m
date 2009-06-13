Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZFMIHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZFMIHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 04:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZFMIHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 04:07:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:26867 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZFMIHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 04:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:from:organization:cc:content-type:mime-version
         :content-transfer-encoding:message-id:user-agent;
        b=EFo0xuc9kA9ahFlE7Lb2XJFqNpPnaVdUk06gxtyMedxdbq7n6V3gXKdUu7+AFWgyHS
         k6RnrmF2aAdWuQQ7FJpWY2MzLDsc8ivwf0reeKlXHSQyRiJfCTNh24FDUqj4ZT4DqGtS
         khm1fugWa+9JaB5d19Igue16c2dL/h6Aukj3w=
Date: Sun, 14 Jun 2009 00:07:38 +0800
To: linux-kernel@vger.kernel.org
Subject: I have ported linux onto a new architure (trimedia)
From: "Guo Hongruan" <camelguo@gmail.com>
Organization: Gulessoft, Inc
Cc: "guo.hongruan@gulessoft.com" <guo.hongruan@gulessoft.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uvg0e0jnmn1qzu@ghr-notebook-02.gulessoft.com>
User-Agent: Opera Mail/9.64 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi friends,
    I am happy to tell you that I have ported linux onto a new architure --  
trimedia. I called this project tmlinux. Now tmlinux includes a linux  
kernel, a uclibc, a busybox and a toolchain wrapper. I have validated the  
whole system using LTP. Nearly all of the cases passed.
    TriMedia is a VLIW Mediaprocessor family from NXP Semiconductors  
(formerly Philips Semiconductors). The main challenge of porting linux to  
trimedia is that gcc does not support TriMedia at all. the only available  
compiler for trimedia is tmcc, which can not recognise any gcc extension  
options. To compile the linux kernel and uclibc, I used a CIL (C  
intermedia language) to translate gcc extension options to C99 standard  
source code, and then compile it using tmcc. The result proves that it  
works OK.
    I am happy to share my work to linux world. You can get the whole  
source code through the following URLs:
http://tmlinux.googlecode.com  -- for uclibc, busybox, toolchain wrapper,  
cil, ltp and so on. It is the portal of tmlinux.
git clone git://github.com/camelguo/linux-2.6-trimedia.git  -- for linux  
kernel source code for trimedia.

Any feedback is welcome.

By the way, I am not in the list, please CC to camelguo@gmail.com when  
reply

Thanks a lot.

-- 
Guo Hongruan, Embedded Linux Consultant
Mobile: +86-0-13484056007
Skype: camelguo
Twitter: camelguo
http://www.gulessoft.com
