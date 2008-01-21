Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYAUQpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYAUQpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYAUQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:45:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:41210 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbYAUQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XxlXys05S2/lC+rEJX8KLLfL8bpe4ZkjqHDfNomUymmOLB0kKqQkYrXwengz9i4GAJs+gAGwwvl4YmxYleDyVXoY8YHpR8vfQOtPC6wutWc2bEUuJ8dJdwL+oJ9lpijANd7s+Cpf0NQABgBcn8xlvdjsllmX9fSK6n/O0SiV0DI=
Message-ID: <82e4877d0801210845i4909ff04wef3fb5f985e8cbc1@mail.gmail.com>
Date: Mon, 21 Jan 2008 11:45:04 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: Matthias.Wolle@gmx.de
Subject: Re: LowFree/LowMem problem
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Wolle <Matthias.Wolle <at> gmx.de> writes:

>
> Hi,
>
> my company is running several servers with kernel 2.6.23.12.  This are Dual
> Quad Core servers (CPU Intel) with 16GB RAM using a 32Bit kernel.

This is a common problem with running 32-bit kernels with more than 8Gb RAM.
(Search the archives and you will find similar problem reports.)

Anyone in your situation has two options - Preferred one is to switch
to a 64-bit kernel. In most cases you can just upgrade the kernel to
64-bits and use the same 32-bit userspace. It works fine.

If you cannot for some reason upgrade to a 64-bit kernel, the second
option is to try and use RHEL/CentOS kernels which according to Alan
Cox are better tuned for this kind of setup and you have a better
chance that they will work.

HTH

Parag
