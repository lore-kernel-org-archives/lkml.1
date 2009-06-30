Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZF3Wqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZF3Wqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZF3Wqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:46:37 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64047 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZF3Wqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:46:36 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 18:46:35 EDT
Date: Wed, 1 Jul 2009 00:29:47 +0200
From: Alessandro Rubini <rubini-list@gnudd.com>
To: linux@arm.linux.org.uk
Cc: soni.trilok@gmail.com, leochen@broadcom.com, plagnioj@jcrosoft.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/6][ARM] new ARM SoC support: BCMRing
Message-ID: <20090630222947.GA16628@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'
	n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20090630211249.GA10001@n2100.arm.linux.org.uk>
References: <20090630211249.GA10001@n2100.arm.linux.org.uk>
	<8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C3@SJEXCHCCR02.corp.ad.broa
	dcom.com>
	<8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broa
	dcom.com>  <20090627053317.GG8587@game.jcrosoft.org>
	<8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1A06@SJEXCHCCR02.corp.ad.broa
	dcom.com>
	<5d5443650906292230k27e70863l49566462328f0a43@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. wrap the string.  This is considered bad practice since it means
>    that you can't grep the kernel source for the exact message.

FWIW, I always grep in kernel objects, so I'm immune to both string
splitting and message duplication in drivers I'm not using.

  #!/bin/sh
  find . -name "*.o" -o -name "*.ko" | xargs strings -f | grep ":.*$1"

/alessandro
