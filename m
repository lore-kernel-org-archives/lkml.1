Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZGCGwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZGCGwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZGCGv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:51:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40731 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGCGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=x2OkePg8cMJIzTTmFG9JRn4G6FTkvmD/WWODCgO8xO2UM6PPh6RC2DMGzWV+/85M0Y
         ufKOAm9LN91dmz920SiN3Bw/VVyEQwyseNNwPWmNXmFHBABvRei19gCschURw1EvzX7G
         5dS/ubvi6FO6XaTo8BNIFDHl3HDNcTYjtuZ14=
MIME-Version: 1.0
Date: Fri, 3 Jul 2009 12:14:41 +0530
Message-ID: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
Subject: Inline assembly queries [2]
From: kernel mailz <kernelmailz@googlemail.com>
To: linuxppc-dev@ozlabs.org, gcc-help@gcc.gnu.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for responding to my previous mail. A few more queries

a. What is the use of adding format specifiers in inline assembly
like
asm volatile("ld%U1%X1 %0,%1":"=r"(ret) : "m"(*ptr) : "memory");

b. using m or Z  with a memory address. I tried replacing m/Z but no change
Is there some guideline ?
gcc documentation says Z is obsolete. Is m/Z replaceable ?

- Manish
