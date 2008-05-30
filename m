Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbYE3IFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbYE3IFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYE3IFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:05:00 -0400
Received: from gw.goop.org ([64.81.55.164]:33373 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYE3IE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:04:57 -0400
Message-ID: <483FB503.80708@goop.org>
Date: Fri, 30 May 2008 09:04:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu> <483FAF5B.3080408@redhat.com>
In-Reply-To: <483FAF5B.3080408@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Have a define like this for them all?
>
> #define page_aligned \
>   __attribute__((aligned(4096))) \
>   __attribute__((__section__ (".bss.page_aligned")))
>
>   

Yes, yesterday I posted some patches to do exactly that.

    J

