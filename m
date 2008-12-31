Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYLaUoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYLaUoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLaUny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:43:54 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:43199 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYLaUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:43:53 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
References: <20081231074356.GA28946@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain>
 <alpine.LFD.2.00.0812310935080.5086@localhost.localdomain>
Date: Wed, 31 Dec 2008 12:43:46 -0800
In-Reply-To: <alpine.LFD.2.00.0812310935080.5086@localhost.localdomain>
 (Linus Torvalds's message of "Wed, 31 Dec 2008 09:41:59 -0800 (PST)")
Message-ID: <7v3ag4xegt.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: BBD768EA-D77B-11DD-BCA7-5720C92D7133-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> In case you wonder what the easiest way to fix things up is: just export 
> the series as a mbox ("git log -p --stat --pretty=email linus.. > mbox") 
> and then just edit the single mbox file to remove crud. Then you can 
> re-apply it with "git am".
>
> Of course, with git you can do it in a million different ways: You could 
> do it with "git format-patch" or with "git rebase -i" too, for example, 
> but exporting it as an mbox means that you can do it in one single editing 
> session, which is how at least I personally work. Much nicer than having 
> to handle each commit individually.

The "format-patch" equivalent to export to a single mbox is:

    $ git format-patch --stdout linus.. >mbox

