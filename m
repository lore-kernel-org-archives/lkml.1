Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXGDKOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXGDKOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbXGDKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:14:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842AbXGDKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jIR55fQNwjS48kcxuQ1sEbDdrKWIwMnQN62RJwHQ42fV73am42glVIuku+jbpTzPjRv7FsLZ2vmq90dHOwBPLCH5AE4YoOnCbE4+7SNG2k4gQToJ/D9yStJthoZG60qeMZ5aqOGZVfTFCWDnVVTFyzNAadcoLd3OPRvl479h2oQ=
Message-ID: <9a8748490707040314l3166bdacy75c9394ca017c0ec@mail.gmail.com>
Date: Wed, 4 Jul 2007 12:14:26 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Turbo Fredriksson" <turbo@bayour.com>
Subject: Re: Forcibly remove broken disk from LV
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <9a8748490707040313g4f89dfe2obf9ff73d5ef22307@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87lkdwa4sb.fsf@pumba.bayour.com>
	 <9a8748490707040313g4f89dfe2obf9ff73d5ef22307@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 04/07/07, Turbo Fredriksson <turbo@bayour.com> wrote:
> > I have a disk that only gives SCSI errors etc which
> > I want to remove from the VG. But vgreduce only hangs
> > and so does pvremove...
> >
> > If I physically remove the disk, the vg/pv/lv etc isn't
> > accessible so the vgreduce won't work (claims that it
> > can't find any PV's etc).
> >
> > So how do I remove the disk?
>
> vgreduce --removemissing
>
> should do the trick I'd say.
>
Ohh and by the way, pvremove also has a --force option - if needed.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
