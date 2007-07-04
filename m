Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXGDKNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXGDKNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXGDKN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:13:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:10659 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbXGDKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AOPC/4RmYuRW/aj7z1sUUggwxXKlGXjIvArUfXaJBMyMympdjJe6QsumJb1iK5eMmv+iF/d3NcHJCrJF8YfZWYbEFHy/5hJLJ0YsjaNwnDme1J8eBddxatANyQ37Z71AO5IyigveMZM6VO1xYJfdpZYCmtAFiJkjr2OTMPjkw1o=
Message-ID: <9a8748490707040313g4f89dfe2obf9ff73d5ef22307@mail.gmail.com>
Date: Wed, 4 Jul 2007 12:13:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Turbo Fredriksson" <turbo@bayour.com>
Subject: Re: Forcibly remove broken disk from LV
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <87lkdwa4sb.fsf@pumba.bayour.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87lkdwa4sb.fsf@pumba.bayour.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/07, Turbo Fredriksson <turbo@bayour.com> wrote:
> I have a disk that only gives SCSI errors etc which
> I want to remove from the VG. But vgreduce only hangs
> and so does pvremove...
>
> If I physically remove the disk, the vg/pv/lv etc isn't
> accessible so the vgreduce won't work (claims that it
> can't find any PV's etc).
>
> So how do I remove the disk?

vgreduce --removemissing

should do the trick I'd say.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
