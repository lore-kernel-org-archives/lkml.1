Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752560AbYLRKUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYLRKUP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYLRKT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:19:56 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39857 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLRKTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:19:55 -0500
Message-Id: <494A31F0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 18 Dec 2008 10:20:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>,
        "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander van Heukelum" <heukelum@mailshack.com>,
        <linux-arch@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in
	 assembly files
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
 <20081217172640.GB5436@uranus.ravnborg.org>
 <20081217173824.GF8078@localhost>
 <20081217180023.GA5783@uranus.ravnborg.org>
 <1229593918.31758.1290707307@webmail.messagingengine.com>
In-Reply-To: <1229593918.31758.1290707307@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Alexander van Heukelum" <heukelum@fastmail.fm> 18.12.08 10:51 >>>
>Agreed. I vote to complement the existing ENDPROC annotation with
>the proposed PROC annotation. Let's call that an extension, not
>something new ;). As it stands it is not impossible to go with
>ENTRY/ENDPROC for code and ENTRY/END for data. However, ENTRY

Not really: At least on ia64 these cannot be mixed (and there as well as
any other architectures that may have such requirements) replacing
ENTRY() with PROC() and END() with ENDPROC() will likely be necessary.

>implies alignment and the prefered alignment for code and data
>might differ.

Jan

