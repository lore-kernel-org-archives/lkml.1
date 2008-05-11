Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYEKR1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYEKR1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYEKR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:27:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:17464 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYEKR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BdrJxatWHGZxADkxd+13hznwwssW/NXw9N+e1o8Dpazbj/1yMPt+6fetGGHUr4iq/qL/I048Gs5N9h/PZYCdr//sjkAyCIxlkztckJmLCzkWfRKoWHO0o0ytnHvErmDzuZe9zgVRbh3uCF+vdE5pl9v/mO6ZjjITDhpbzeCWo10=
Message-ID: <ea11fea30805111027x63aa4e44m81407296d16766d8@mail.gmail.com>
Date: Sun, 11 May 2008 22:57:12 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove unused variable "cpu" from arch/x86/xen/setup.c
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
