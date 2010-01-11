Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290Ab0AKKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab0AKKtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179Ab0AKKtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:49:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58672 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750712Ab0AKKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:49:16 -0500
Date: Mon, 11 Jan 2010 10:52:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Michal Marek <mmarek@suse.cz>,
       Simon Horman <horms@verge.net.au>, Roland Dreier <rdreier@cisco.com>,
       Sam Ravnborg <sam@ravnborg.org>, Sergei Trofimovich <slyfox@inbox.ru>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
Message-ID: <20100111105201.2d86135b@lxorguk.ukuu.org.uk>
In-Reply-To: <4B47CACA.7080103@zytor.com>
References: <20100108115745.GA14758@sepie.suse.cz>
	<1262952988-16563-1-git-send-email-mmarek@suse.cz>
	<4B47C94E.8070302@redhat.com>
	<4B47CACA.7080103@zytor.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is tolower/toupper()?  Do there exist locales where tolower/toupper
> on ASCII input do weird things, or are we merely hypothesizing?

Turkish is the famous one for this and usually causes
internationalisation chaos. So yes they exist, and there are worse more
esoteric cases. There are good reasons sed and friends support classes as
well as old C locale style ranges.

Alan
