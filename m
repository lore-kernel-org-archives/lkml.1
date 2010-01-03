Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837Ab0ACLg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0ACLg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 06:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809Ab0ACLgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 06:36:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:13048 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0ACLgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 06:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kJuQVxe4EYnDOCjxqrYLfDFFyHC8heyC1BsUoFEIsY8u3i8142ZCjkUHrTTAsy/wpb
         sNQevcdJIbiYygX91IXkff7c9R9VcerHjpInKUF4aZPgWuj3mQkI6v/0kFHSiSe3owVZ
         63GxORljMD14UWSrs6NeEbGVvHOedpwi66BTc=
MIME-Version: 1.0
In-Reply-To: <NJVdobuNFNK.A.pdF.3mhOLB@chimera>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	 <NJVdobuNFNK.A.pdF.3mhOLB@chimera>
Date: Sun, 3 Jan 2010 13:36:20 +0200
X-Google-Sender-Auth: 4221a6b1cf5794c5
Message-ID: <84144f021001030336y30444880vb6b9c251eb8a049a@mail.gmail.com>
Subject: Re: [Bug #14951] lockdep possible recursive lock in slab 
	parent->list->rlock
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Tue, Dec 29, 2009 at 5:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14951
> Subject         : lockdep possible recursive lock in slab parent->list->rlock
> Submitter       : Andi Kleen <andi@firstfloor.org>
> Date            : 2009-12-27 12:06 (3 days old)
> References      : http://marc.info/?l=linux-kernel&m=126191560531463&w=4
> Handled-By      : Pekka Enberg <penberg@cs.helsinki.fi>
> Patch           : http://patchwork.kernel.org/patch/69829/

This bug is fixed by the following commit in Linus' tree:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00afa758067ac1c947149ef766adcdfe30c44d7d
