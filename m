Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYEKR0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYEKR0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYEKR0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:26:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:15729 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYEKR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s0Yv8nwSD2wMiXbZn03JOfd4JYtTspLW+sPBzh2aaDL/JD5t5j15onp3w9PjCp0shvnbzVnY5c3EYIhB17HfkA8NOZ2fdkti63a17MxGyHNl7oyHxg14wsSO9vwtNZRq8ETDHhY3JabABbi9JESgiQA5B5gKtqOaQk7GZhpc8F8=
Message-ID: <ea11fea30805111026o448f5711nc6db445db0995b5c@mail.gmail.com>
Date: Sun, 11 May 2008 22:56:13 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Remove unused variable "cpu" from arch/x86/xen/setup.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove unused variable "cpu" from arch/x86/xen/setup.c


Signed-off-by : Manish Katiyar (mkatiyar@gmail.com)

diff -Nur a/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c       2008-04-26 20:36:15.000000000 +0530
+++ b/arch/x86/xen/setup.c    2008-05-11 22:50:35.000000000 +0530
@@ -71,7 +71,6 @@

 void xen_enable_sysenter(void)
 {
-       int cpu = smp_processor_id();
        extern void xen_sysenter_target(void);
        /* Mask events on entry, even though they get enabled immediately */
        static struct callback_register sysenter = {


-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
