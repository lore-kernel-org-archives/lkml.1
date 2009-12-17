Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbZLQXkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbZLQXkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZLQXkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:40:36 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23683 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZLQXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:40:34 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGVQKkurR7H+/2dsb2JhbAC/GJcqgjuBcgQ
X-IronPort-AV: E=Sophos;i="4.47,415,1257120000"; 
   d="scan'208";a="451733122"
From: Roland Dreier <rdreier@cisco.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, mmarek@suse.cz,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC to C
References: <4B2A1761.4070904@suse.cz>
	<tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org>
	<20091217220951.GB4236@merkur.ravnborg.org>
	<4B2AB07D.5010007@zytor.com> <4B2AC01E.6090509@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Dec 2009 15:40:33 -0800
In-Reply-To: <4B2AC01E.6090509@redhat.com> (Masami Hiramatsu's message of
	"Thu, 17 Dec 2009 18:34:54 -0500")
Message-ID: <ada8wd141am.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 23:40:33.0446 (UTC) FILETIME=[53537C60:01CA7F72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > btw, something went wrong with it...

 > make[3]: `scripts/unifdef' ???????

 > when I ran with LC_ALL=C, it shows message correctly.

 > make[3]: `scripts/unifdef' is up to date.

Do you have LANG and/or LC_MESSAGES set?  LC_ALL will override all other
locale settings, so hpa explicitly unset it so that the other LC_xxx
variables will be used.  But it means your environment's LC_MESSAGES (or
LANG if LC_MESSAGES is not set) will be used.

 - R.
