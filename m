Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbZKFUzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbZKFUzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZKFUzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:55:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44451 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbZKFUzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:55:42 -0500
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091106141742.GA1428@ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 12:55:33 -0800
In-Reply-To: <20091106141742.GA1428@ucw.cz> (Pavel Machek's message of "Fri\, 6 Nov 2009 15\:17\:42 +0100")
Message-ID: <m17hu3xtiy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Thu 2009-11-05 15:27:06, Miklos Szeredi wrote:
>> On Thu, 5 Nov 2009, Alan Cox wrote:
>> > >  - re-opening normally after checking file type (there's a debate
>> > >    whether this would have security issues, but currently we do allow
>> > >    re-opening with increased permissions thorugh /proc/*/fd)
>> > 
>> > Which has already been demonstrated to be an (unfixed) security hole.
>> 
>> No it hasn't :)  Jamie theorized that there *might* be a real world
>> situation where the application writer didn't anticipate this
>> behavior.  But as to actual demonstration, we have not seen one yet, I
>> think.
>
> See bugtraq, or lkml thread about symlinks with permissions. There's
> demo script there.

Exactly a theoretical discussion, that demonstrates user space
applications with security holes can be written if they make
assumptions about the world that are not true.

So far no one who believes this to be a security hole has found it
worth their while to look at nd->intent.open in proc_pid_follow_link
and write a patch.    Pavel you started out asking for help on how
to do that and I think I have answered the original question.

I am tired of the whining.  If no one who is persuaded the kernel is
wrong can be bothered to write a possibly buggy 5 line patch this is
clearly not a security hole.

Eric
