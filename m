Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYE1WFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYE1WFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYE1WFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:05:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:44545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYE1WFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WSk/ZQ4xu14x3vfhzqCybWyjs/M7B55Ckrnjx+MboHkhIPLlAEbdGozviyo1Xj1blRj3TeorcwDMfoFKM08mtJDF36KOQY9AjBApQ3zFHCwx1hOZKYeAO6C1mDlbr0CeA0eh98q+jGmxXeXyoRmEvCs4qLhMqL01QkUqrW97jqI=
Message-ID: <6844644e0805281505g7dc813b9x5ee544e5fe957f6b@mail.gmail.com>
Date: Wed, 28 May 2008 18:05:28 -0400
From: "Doug Reiland" <dreiland@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: KBUILD_DEFCONFIG change
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following used to work:
ARCH=ia64 KBUILD_DEFCONFIG=bigsur_defconfig make defconfig

Now 2.6.25 makes you do:

ARCH=ia64 make KBUILD_DEFCONFIG=bigsur_defconfig defconfig

Is this my intent?

It seems like the arch/<xxxx>/Makefile files should be:
KBUILD_DEFCONFIG ?= generic_defconfig

Instead of
KBUILD_DEFCONFIG := generic_defconfig
