Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZGVVPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZGVVPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZGVVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:15:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:30599 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZGVVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EODM9LROIP+W6iojVdQXIzvSy488hKiX7kG+6r5bCZW8zV6KqlRUAdKuQYBoJRZDnR
         HT94uN+zTFaWJorAcVNbNTkmxCX1xenTfrtvnd0m4OGVHWG3ZMNKm3M/FWChCpUW0WiS
         7vQnWYEirsb5s7nu0i9A4ZUd3pEfRxuXRGWpo=
MIME-Version: 1.0
Date: Wed, 22 Jul 2009 14:15:08 -0700
Message-ID: <110c8b2e0907221415q77f7416ehcff4ad26d834bce2@mail.gmail.com>
Subject: Way to combine kernel and initrd on x86 platform?
From: Subodh Nijsure <nijsure.subodh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been using the arch/powerpc/boot/wrapper scripts to combine
linux and initrd.gz to create a single image for distribution.

Is there similar wrapper possible for x86 platforms also? This is my
first week of working on x86 embedded platform.

I know of initramfs option in 2.6 kernel, however the contents of
initrd in my case are created after the kernel is build i.e. will have
to "patch in" the initramfs at later point in build process.

/Subodh
