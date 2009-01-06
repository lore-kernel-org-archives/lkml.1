Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZAFCvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZAFCvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZAFCv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:51:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbZAFCv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:51:26 -0500
Date: Mon, 5 Jan 2009 18:51:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alasdair G Kergon <agk@redhat.com>
cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@suse.de>, Cheng Renquan <crquan@gmail.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
In-Reply-To: <20090105191824.GP5098@agk.fab.redhat.com>
Message-ID: <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
References: <20081010125159.GK5098@agk.fab.redhat.com> <20090105191824.GP5098@agk.fab.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Alasdair G Kergon wrote:
>
> Please pull from:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
> 
> to get the following device-mapper patches for 2.6.29:

Oh no, this is totally broken, and doesn't compile even with my fairly 
minimal install:

  drivers/md/dm-target.c: In function ¡dm_unregister_target¢:
  drivers/md/dm-target.c:106: error: implicit declaration of function ¡module_refcount¢

Not pulled.

		Linus
