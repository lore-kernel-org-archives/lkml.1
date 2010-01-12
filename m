Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615Ab0ALAvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0ALAvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590Ab0ALAvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:51:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0ALAvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:51:13 -0500
Message-ID: <4B4BC75B.405@zytor.com>
Date: Mon, 11 Jan 2010 16:50:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Michal Marek <mmarek@suse.cz>,
       Simon Horman <horms@verge.net.au>, Roland Dreier <rdreier@cisco.com>,
       Sam Ravnborg <sam@ravnborg.org>, Sergei Trofimovich <slyfox@inbox.ru>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz>	<1262952988-16563-1-git-send-email-mmarek@suse.cz>	<4B47C94E.8070302@redhat.com>	<4B47CACA.7080103@zytor.com> <20100111105201.2d86135b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100111105201.2d86135b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 02:52 AM, Alan Cox wrote:
>> This is tolower/toupper()?  Do there exist locales where tolower/toupper
>> on ASCII input do weird things, or are we merely hypothesizing?
> 
> Turkish is the famous one for this and usually causes
> internationalisation chaos. So yes they exist, and there are worse more
> esoteric cases. There are good reasons sed and friends support classes as
> well as old C locale style ranges.
> 

Ah yes, forgot about Turkish.  Apparently Lithuanian and Azeri also have
special rules for the letters I and J.  Sigh.

	-hpa

