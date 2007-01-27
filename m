Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbXA0QOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbXA0QOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXA0QOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:14:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:41367 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXA0QOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=QJE54SD82ONLO7QGqyCJyJiCwghnIkSA4jp7o/cukWeAY3G9I1gC3fEh4Jz0NUl3y80I+gD7mmSUE5K1/3zKGjqeh3ehknDAo3iXX/wvCNDnfaOpQBqPQA1i3x7jUrYojuzaIcD6jsphgMxFZFRekpYWLu8bnAzhIHVfrQ1n8Rs=
Message-ID: <45BB7A50.6050504@googlemail.com>
Date: Sat, 27 Jan 2007 17:14:08 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Claas Langbehn <claas@rootdir.de>,
       Dave Airlie <airlied@linux.ie>, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Claas,

akpm@osdl.org napisał(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

$ quilt patches drivers/char/drm/via_3d_reg.h
patches/updates-to-via-dri.patch

drivers/char/drm/via_verifier.c: In function ‘via_parse_header2’:
drivers/char/drm/via_verifier.c:737: error: ‘HC_REG_TRANS_SPACE’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:737: error: (Each undeclared identifier is reported only once
drivers/char/drm/via_verifier.c:737: error: for each function it appears in.)
drivers/char/drm/via_verifier.c:754: error: ‘VIA_VIDEOMASK’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:754: error: ‘VIA_VIDEO_HEADER5’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:755: error: ‘VIA_VIDEO_HEADER6’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c: In function ‘via_check_vheader5’:
drivers/char/drm/via_verifier.c:866: error: ‘VIA_VIDEOMASK’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c: In function ‘via_parse_vheader5’:
drivers/char/drm/via_verifier.c:895: error: ‘VIA_VIDEOMASK’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c: In function ‘via_verify_command_stream’:
drivers/char/drm/via_verifier.c:1013: error: ‘VIA_VIDEOMASK’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:1013: error: ‘VIA_VIDEO_HEADER5’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:1016: error: ‘VIA_VIDEO_HEADER6’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c: In function ‘via_parse_command_stream’:
drivers/char/drm/via_verifier.c:1074: error: ‘VIA_VIDEOMASK’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:1074: error: ‘VIA_VIDEO_HEADER5’ undeclared (first use in this function)
drivers/char/drm/via_verifier.c:1076: error: ‘VIA_VIDEO_HEADER6’ undeclared (first use in this function)
make[3]: *** [drivers/char/drm/via_verifier.o] Błąd 1
make[2]: *** [drivers/char/drm] Błąd 2
make[1]: *** [drivers/char] Błąd 2
make: *** [drivers] Błąd 2

Please fix this driver.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
