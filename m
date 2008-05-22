Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbYEVMlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbYEVMlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbYEVMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:41:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:10381 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbYEVMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qdC725tfUsXLtrCRH9kmLE4eo5JsH/jAzXxIRpikPgoW6OjXOiq9OCvpnrqKVxao4Do6dGF6Sb2PKAR45Au3p/FoCYab4BP/0tS1j2xg7u8absX+xrVPnQm/rCa524giVHPijcDCOBas0+pJ3gW8WlDntuXeqvrY/7uCMW6dJQc=
Message-ID: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Date: Thu, 22 May 2008 14:41:13 +0200
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Inserting code from userspace to kernel space
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm looking for a way to insert code from user space to the kernel
space, but without using kernel module. Actually, we are working on a
system that has to allow end user to change part of code (one or two
functions) that is executed from the kernel space.

For now we have two different kernel modules, one exporting a function
which another module uses. Process of compiling kernel module is quite
ineligible for standard end user (along with the requirement to
support multi platform cross compiling) compared to just cross
compiling a simple code that doesn't use any libraries than libc.

I know this sounds quite weird, but maybe there is a project that can help us ;)

Sincerely,
Bosko
