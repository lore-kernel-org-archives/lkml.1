Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYC1IOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYC1IOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbYC1IOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:14:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26326 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYC1IOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=gTm6OG6LjuYjczWv50uA3+E3skw3kkFl63Sh3EKC0A5YJkoRAs2Xxgk+AdX3TWucIWEFWV7TtU+kAx45RXFmf6+SO6AGwDc8hQxsYzLvt/VNozTXHYwIF3hueJ01uFzYzXxZpps5IYRpCvCYdNrZRkA5dvAAR1X0T+GiTRwTcas=
Date: Fri, 28 Mar 2008 09:13:35 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: something wrong with ^C
Message-ID: <20080328081335.GF29622@slug>
References: <20080327142814.GC13190@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327142814.GC13190@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 03:28:14PM +0100, Pavel Machek wrote:
> Hi!
> 
> Is it just me, or does ^C take longer in 2.6.25?
> 
> Like... one second delay between pressing ^C and seeing any effect?
I suspect I'm hitting the same thing. I was suspecting my terminal
(mrxvt) but it has problably nothing to do with it.
Something to do with the scheduler? Like:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=62fb185130e4d420f71a30ff59d8b16b74ef5d2b

Regards,
Frederik
