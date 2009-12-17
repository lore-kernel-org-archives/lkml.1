Return-Path: <linux-kernel-owner+w=401wt.eu-S936294AbZLQEJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294AbZLQEJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936176AbZLQEJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:09:16 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:44805 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936221AbZLQEJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:09:09 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADI9KUurRN+J/2dsb2JhbAC+WJZ/hCsE
X-IronPort-AV: E=Sophos;i="4.47,410,1257120000"; 
   d="scan'208";a="63912687"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>
	<adabphy750b.fsf@roland-alpha.cisco.com> <4B299AB5.7020109@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 20:09:07 -0800
In-Reply-To: <4B299AB5.7020109@zytor.com> (H. Peter Anvin's message of "Wed,
	16 Dec 2009 18:43:01 -0800")
Message-ID: <ada7hsm6y3g.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 04:09:07.0666 (UTC) FILETIME=[ADBC9320:01CA7ECE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > Is there any reason not to apply the patch below, to allow more awk
 > > implementations to be used?  After all, it's not like we're going to put
 > > non-ASCII characters into the map file...

 > I guess the question is if it will break under any other circumstances,
 > but I guess we can find those when we get to them.

I should have mentioned it, but with the current Debian testing version
(mawk 1.3.3-15) and my patch, I get a byte-for-byte identical
inat-tables.c to what I get with the unpatched kernel and gawk
1:3.1.6.dfsg-4.

I'm not sure how likely all this is to change in the future, but it's
hard for me to see a sane reason why eg [:lower:] and a-z would be
different for this use.

 - R.
