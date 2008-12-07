Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYLGEpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYLGEpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYLGEpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:45:39 -0500
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:42748 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753591AbYLGEpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:45:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Ntln32V9xjabRYdbr+MGvXRJN3daxWooLoZBcG2mvv9Fq9n7AYrwT2+bPbw1n+TAnAAAcquEr+ikbmAqxh3iL29FKzUbnKaL3tQLSAViuPerF23Lo/h+fIRxBY6fOx8t;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] Sound (HDA Intel): Restore PCI configuration space with interrupts off
Date: Sat, 6 Dec 2008 20:45:35 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl> <200812061509.08994.rjw@sisk.pl>
In-Reply-To: <200812061509.08994.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062045.35689.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 6, 2008 6:09 am Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Sound (HDA Intel): Restore PCI configuration space with interrupts
> off
>
> Move the restoration of the standard PCI configuration registers
> in the snd_hda_intel driver to a ->resume_early() callback executed
> with interrupts disabled, since doing that with interrupts enabled
> may lead to problems in some cases.
>
> This patch addresses the regression from 2.6.26 tracked as
> http://bugzilla.kernel.org/show_bug.cgi?id=12121 .

Since I only applied 1 and 2 you'll need to send this one through Takashi.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

