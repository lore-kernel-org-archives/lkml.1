Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab0CCRTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:19:14 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58234 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab0CCRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bzpNXf1hbM32O7p7uXNtGlud6meEAiMG10a0UI97qB8EALnLlXHvJJ4MErMkFbaNdW
         kpZoomVWfAod8vBOk6mG2g060itV987Tv0plCuV+GEcpsIeoTwW+G1pZucjSIOWyTQXh
         GjfVL7CmWiGBW+2/1QcOXxs7th3MUa2RqwoCw=
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 22:41:22 +0530
Message-ID: <f22d86811003030911s3d857c8do58f2c8e904ac4eac@mail.gmail.com>
Subject: Replacing kernel functions - kernel symtab
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am working on a module which provides dynamic instrumentation for
some of the kernel
functions. My module is not ready yet from dynamic instrumentation perspective.

In order to test basic functionality, I am planning to hijack calls
like kmalloc in order to provide
some profiling information. I was thinking of replacing the symbols in
the kernel symbol table
just for testing purposes. I know this is not a clean approach.

Would it possible to replace kmalloc with my_kmalloc in my modules
init function? This way, after
my module is loaded all mallocs are routed to my module. What could go
wrong here? Logically,
this is just point replacement in symtab which should be atomic, right?

Is there any other way to trap calls like kmalloc without making
changes in mm subsystem or compiling
kernel/rebooting? In user space we have multiple options like usage of
LD_PRELOAD etc, are there
any loading time tricks which we can use in kernel space?



-Leo.
