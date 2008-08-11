Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYHKULp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYHKULp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYHKUL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:11:27 -0400
Received: from brmea-mail-3.Sun.COM ([192.18.98.34]:32989 "EHLO
	brmea-mail-3.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYHKUL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:11:26 -0400
Date: Mon, 11 Aug 2008 12:11:07 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
In-reply-to: <20080811065608.44687f65@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>,
       Adrian Bunk <bunk@kernel.org>, tvrtko.ursulin@sophos.com,
       Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Reply-to: davecb@sun.com
Message-id: <48A0649B.4010706@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Accept-Language: en-us, en
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
 <200808070349.55882.mdontu@bitdefender.com>
 <20080806213904.37a33a58@infradead.org>
 <200808111645.48177.mdontu@bitdefender.com>
 <20080811065608.44687f65@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>>just to get things clear; yyou're [ talking about ...] detecting
>>>the presence and preventing to (accidental) use of pre-canned,
>>>widely used exploit binaries/files ?

Mihai Donțu <mdontu@bitdefender.com> wrote:
>>I apologize for the late reply. The answer to your question is: yes.
>>I was planning to write some more on this subject 

Arjan van de Ven wrote:
> we do still appreciate your description, since I don't think there's a
> clear "here's what we really try to protect against" statement yet.

  Perhaps I could try: the AV folks are trying to prevent the
execution of either modified normal binaries/files or 
specifically exploit binaries/files, by machines for which the 
files are executable or interpretable.

  The experience of those communities is predominantly
with DOS/Windows executables and interpretable files, which
they have difficulty generalizing from.

  In principle, they could be targeted at any machine, so any
mechanisms should be applicable to native executables and
interpretables as well as foreign ones.

--dave (who (in)famously wrote a UUCP virus, which warned sysadmins 
        if they had bad enough security settings to have run it as root) c-b
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
