Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZL1UnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZL1UnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZL1UnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:43:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59529 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZL1UnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BE26sD+O/DoxH3vK1iSMHIGF1DqmRZ6hQF3Coc3bgYG3fXYTj19jJsiMsaWjDBEkcI
         X7RiSst38HKTt9jQm8v3aItFOLhB/N07g8AtMlA0FdP5g1h7ZsNnhWfsMgQFMX3IhI6n
         GFfFNFDTDe6xA6FcD2ubmOOo0vwzGxjkpc6UQ=
MIME-Version: 1.0
Date: Mon, 28 Dec 2009 15:43:07 -0500
Message-ID: <b3eb0ed40912281243p3f59f9f6vb278f25e18eaa172@mail.gmail.com>
Subject: Oops in 2.6.27.39 vanilla kernel with latest DTrace linux port
From: Soumendu Satapathy <satapathy.soumendu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://patchwork.kernel.org/patch/69319/

I have sent my patch to the DTrace for linux author. he will try to
incorporate it in the standard release.

- soumendu

---------- Forwarded message ----------
From:  <fox@crisp.demon.co.uk>
Date: Wed, Dec 23, 2009 at 5:25 AM
Subject: Re: Fwd: Opps in 2.6.27.39 vanilla kernel with DTrace
To: satapathy.soumendu@gmail.com



> From: Soumendu Satapathy
> Date: Tue, Dec 22, 2009 at 11:18 AM
> Subject: Opps in 2.6.27.39 vanilla kernel with DTrace
> To: blog@crisp.demon.co.uk
>
>
> Hi Paul,
>
> 10/10/2009 09:50PM        814,999
> dtrace-20091010.tar.bz2
> ( I used this tarrball )
> I was able to use the DTrace perfectly well with 2.6.18 (x86_64). But I had
> problems with the latest DTrace  port on 2.6.27.39.(x86_64).
>
> I did the following changes inside the routine mem_set_writable() (
> driver/dtrace_linux.c) and I could make it work with 2.6.27.39.
>
> if (pmd_large(*pmd)) {
>                 pte = (pte_t *)pmd;
> }
> else {
>                 pte = pte_offset_kernel(pmd, addr);
>  }
>
> thanks
> Soumendu Sekhar Satapathy

Thank you Soumendu - glad you got that working, and let me know the
patch. I will try incorporating that into the standard release.

seasons greetings.



+-------------------------------------------------------------------------+
| CRiSP WebNews:        http://www.crisp.demon.co.uk/webnews.html         |
+-----------------------------+-------------------------------------------+
| CRiSP - Flexible editor     | CRiSP, syn. for BRIEF                     |
| www.twitter.com/crispeditor | Internet:          CRiSP.Editor@gmail.com |
|                             | WWW: (mine)  http://www.crisp.demon.co.uk |
|                             | WWW:                 http://www.crisp.com |
|                             | WWW:           http://www.pacemaker.co.uk |
+-------------------------------------------------------------------------+
   5707* display.c: Fix last fix: couldnt move cursor on the bottom
         window of a split window.
