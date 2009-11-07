Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbZKGHuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbZKGHuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 02:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZKGHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 02:50:04 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56628 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZKGHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 02:50:03 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
CC: pavel@ucw.cz, miklos@szeredi.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <m17hu3xtiy.fsf@fess.ebiederm.org>
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091106141742.GA1428@ucw.cz> <m17hu3xtiy.fsf@fess.ebiederm.org>
Message-Id: <E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Nov 2009 08:49:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Nov 2009, ebiederm@xmission.com (Eric W. Biederman wrote:
> So far no one who believes this to be a security hole has found it
> worth their while to look at nd->intent.open in proc_pid_follow_link
> and write a patch.

A rather disgusting patch that would be.  The fact is, checking
permissions on follow_link makes little to no sense.  Consider
truncate(2), for example.  Will we add another intent for that?  I
really hope not.

I'm more and more convinced, that the current behavior is the right
one.

Thanks,
Miklos
