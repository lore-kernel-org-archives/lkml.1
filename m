Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXIYJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXIYJ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXIYJ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:28:06 -0400
Received: from mta-fs-be-05.sunrise.ch ([194.158.229.18]:38497 "EHLO
	mail-fs.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912AbXIYJ2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:28:04 -0400
Date: Tue, 25 Sep 2007 09:27:59 +0000
Message-ID: <46D217B100015CAD@mta-fs-be-05.sunrise.ch>
In-Reply-To: <46F859B2.8000209@goop.org>
From: osth@freesurf.ch
Subject: Re: Xen kernel 2.6.23-rc7 bug at xen_mc_flush (arch/i386/xen/multicalls.c:68)
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Hm, it just seems that its trying to unpin an mm on the error path of
>execve, and so it hasn't been pinned.  The simplest way to reproduce is:
...
>Anyway, try this patch.
Bug is solved by this patch. Thanks! - Maybe this patch can make it into
2.6.23 final?

Christian Ostheimer


Neu: Das erste ADSL-Abo ohne Monatsgebühr! Steigen Sie jetzt auf sunrise
ADSL free um.
http://www.sunrise.ch/privatkunden/iminternetsurfen/adsl/adsl_abosundpreise/adsl_gelegenheitssurfer/adsl_free.htm



