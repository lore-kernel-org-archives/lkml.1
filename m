Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbXB0Osh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbXB0Osh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXB0Osh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:48:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:57478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXB0Osg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kh10VWd1K+o+4g7/LfBd51lsN0eo5Ld1xQJ6pwJQ+1NJXe53sydT5nn7jUUonF+l/fH/PJEfLmSXVuJUa3D8tEys8ogvlr++3CXP5vQwbsxj1ni0Ph+hm9fGDmaHpbno6NH/nWPMPNbflViY9/lby/ZqmCtFto+9MoHAgpTrjJ4=
Message-ID: <84144f020702270648o32fb15dfg4267f0cb5b50454a@mail.gmail.com>
Date: Tue, 27 Feb 2007 16:48:25 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Chris Rankin" <rankincj@yahoo.com>
Subject: Re: [Alsa-devel] [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
Cc: "Takashi Iwai" <tiwai@suse.de>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <797678.74613.qm@web52901.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5h7iu4heun.wl%tiwai@suse.de>
	 <797678.74613.qm@web52901.mail.yahoo.com>
X-Google-Sender-Auth: 13940f6be2862811
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Chris Rankin <rankincj@yahoo.com> wrote:
> Hmm, this bug looks interesting:
>
> http://www.ussg.iu.edu/hypermail/linux/kernel/0702.3/0514.html
>
> Yes, my machine *is* a dual P4 with HT enabled...

Yeah, but the oops looks more like a reference counting problem with
sysfs dentries. No harm in trying out the patch or reproducing without
CONFIG_SCHED_SMT though.
