Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYB0VA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYB0VA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYB0VAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYB0VAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=f8t/YeXLJlGW+fo52d3Vx1/GOzhBCdO/5rP8cc2QDsAgFoR0ZqNe1KwRhoGN6EQYlY0M8MqA34t3/EWFc8ymJhz9Pve6zdjP/smBg75BqzbcJ0bZnHsweZl9KKnXZUHWfXGg5phugrWdcCf9jBYQzdm1+fU/EI+4QHP5qGzHNRE=
Message-Id: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:31 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 00/10] vmlinux.lds cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches is made in purpose to use PAGE_SIZE and THREAD_SIZE
macroses in vmlinux linker scripts as much as possible instead of numeric
constants. Please review.

        WARNING: the patches are UNTESTED COMPLETELY - I've no access to
        that architectures and errors is highly possible ;)

	If you have an ability to test this patches - please do it.
	What is most important on review - these macroses *must* be
	placed into appropriate places - check it please.

	ANY comments are welcome.

		- Cyrill -

-- 
