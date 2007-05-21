Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbXEURgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbXEURgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXEURgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:36:12 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:55682 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbXEURgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BRo8ejQqg+LD7D4IdYuLd/4FM7lJpZyCuQswf2g2TA/wsTVmxdBJXs/fme9d7KLDFNzQ4O1Egi5CoBt97kQWERXdux0MrxZXWdb9IoWsRFHwvdKBivzM/eCU4kRsSocBB/dzsKTtJ5tknIPSI7xMfRhSsv/n/nwzko5IL3gHJ+I=
Message-ID: <8bd0f97a0705211036q1162e9edvd73af8d6c536e565@mail.gmail.com>
Date: Mon, 21 May 2007 12:36:10 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200705211035.08380.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <200705211035.08380.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> since there is noMMU, are we better:
>  - putting stubs (return ENOSYS - give runtime errors), or
>  - just ignore the errors - and give compile errors? (Is there any way to put
> something into the syscall table, as not to get the warnings?)

there are no compile errors ... having a stub that returns -ENOSYS is
the same thing as not having a stub as the fallback code when given an
unknown syscall # will return -ENOSYS ...
-mike
