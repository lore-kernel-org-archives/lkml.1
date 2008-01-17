Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbYAQW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbYAQW4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762141AbYAQWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:52:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:19228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761457AbYAQWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:52:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=r+caixmW6NNDPbNehINLj5JWdFzzG6j/Y/eiijhg1w2qgbq6zeH07EJPHmDKZKm+D
	0nzlUxKVOwJc7KFbyYwLw==
Message-ID: <4d47a5d10801171451n50c91097m12a22a49e3c04884@mail.gmail.com>
Date: Thu, 17 Jan 2008 17:51:56 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Szabolcs Szakacsits" <szaka@ntfs-3g.org>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "Pavel Machek" <pavel@ucw.cz>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Theodore Tso" <tytso@mit.edu>, "Al Boldi" <a1426z@gawab.com>,
       "Valerie Henson" <val.henson@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0801171130560.12451@tamago.serverit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801090022.55589.a1426z@gawab.com>
	 <200801090740.12989.a1426z@gawab.com>
	 <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	 <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
	 <20080113171916.GB4132@ucw.cz>
	 <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	 <20080115201653.GA5639@elf.ucw.cz>
	 <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
	 <Pine.LNX.4.62.0801171130560.12451@tamago.serverit.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 7:29 AM, Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> Similarly to ZFS, Windows Server 2008 also has self-healing NTFS:

I guess that is enough votes to justify going ahead and trying an
implementation of the reverse mapping ideas I posted.  But of course
more votes for this is better.  If online incremental fsck is
something people want, then please speak up here and that will very
definitely help make it happen.

On the walk-before-run principle, it would initially just be
filesystem checking, not repair.  But even this would help, by setting
per-group checked flags that offline fsck could use to do a much
quicker repair pass.  And it will let you know when a volume needs to
be taken offline without having to build in planned downtime just in
case, which already eats a bunch of nines.

Regards,

Daniel
