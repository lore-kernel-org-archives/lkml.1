Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZKLGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZKLGlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 01:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZKLGlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 01:41:25 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:53802 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZKLGlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 01:41:24 -0500
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 01:41:24 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=IrBKwRB1tGuTzdVkeq6aaj7aUVSOde9YGm/izK5bAFeCpiAxtu0ga2hWni2xMY4NY7
         rhU1sgzHzvMqWneaC0lVCEyR0r37haHqdfgJdLKdtCRR7qmUgLcOcflMsA5k0l+fpAVO
         nNz+HrfixctmsX/wzEhMZNupilc/C4Ue4ttvc=
MIME-Version: 1.0
In-Reply-To: <cb9ecdfa0911112229r3716a90m76f942bb1c95b8ae@mail.gmail.com>
References: <cb9ecdfa0911112229r3716a90m76f942bb1c95b8ae@mail.gmail.com>
Date: Thu, 12 Nov 2009 14:41:30 +0800
Message-ID: <cb9ecdfa0911112241h7183c9a1sc77d51d567fc6ed3@mail.gmail.com>
Subject: Allocate continuous memory and physical address.
From: Johnny Hung <johnny.hacking@gmail.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:
    I am writing user space application and need to allocate a
continuous memory. The size is just 64KB and I also need to know the
allocated physical memory address. Is is possible to do it in user
space or it should be done it kernel space? BTW, how to allocate
continuous physical memory and got it physical address in kernel
space?
    In addition, is there any different between to trigger a SMI
(System Management Interrupt) in user space and kernel space?
    I appreciated if someone give me a point.

BRs, H. Johnny
