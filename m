Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYAPUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYAPUww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYAPUwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:52:43 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:38530 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYAPUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W5BPVJO0uR6q/m1i7bT3Qp0kaa7+dJe1ucwcVQZgPJ2N+djFGb5o6+jBIkisppv02EjBQSMvkIdhLL8BRv4dkb/tI9kXTtNOmH7DtyBdBYGGQdCi+MeGaXFHH+bW5/Ds7lXQeP+Vgy9E6bRxthGWp3DHu+0rGQW1dzZveX0uvPQ=
Message-ID: <70b6f0bf0801161252y1897956y76b9caf52ae0188a@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:52:40 -0800
From: "Valerie Henson" <val.henson@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "Daniel Phillips" <phillips@google.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Theodore Tso" <tytso@mit.edu>,
       "Al Boldi" <a1426z@gawab.com>, "Rik van Riel" <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080116114940.GC22460@elf.ucw.cz>
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
	 <20080116114940.GC22460@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 3:49 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> ext3's "lets fsck on every 20 mounts" is good idea, but it can be
> annoying when developing. Having option to fsck while filesystem is
> online takes that annoyance away.

I'm sure everyone on cc: knows this, but for the record you can change
ext3's fsck on N mounts or every N days to something that makes sense
for your use case.  Usually I just turn it off entirely and run fsck
by hand when I'm worried:

# tune2fs -c 0 -i 0 /dev/whatever

-VAL
