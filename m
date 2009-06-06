Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZFFR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZFFR6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFFR6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 13:58:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:23012 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZFFR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 13:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=nnhnkvURA6fudPi2Q8+cR3uxTh4MhqNsll/49hYdBmrByyVj7YVU7O36ZcWsLoJdWx
         QeGdZS1gvaEUD+xKoYKg4vuhf9DXy3CokCPOHYfbSu7YKfIH1NUjaV8L+snuyToyBD7W
         9/5MvjZ3WFzA/ErWxISQStVjUd8WlilN8iMQk=
Date: Sat, 6 Jun 2009 19:58:36 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ide-tape: fix flags
Message-ID: <20090606175836.GA12865@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com> <200906052034.06668.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200906052034.06668.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:34:06PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 02 June 2009 09:05:06 Borislav Petkov wrote:
> > Hi Bart,
> > 
> > those fix a stupid flags misuse that got spotted by Jiri Slaby. Please
> > pay special attention to the first patch. FWIW, those can go as hot
> > fixes right away and we might catch 30-rc8 since it's not out yet.
> 
> The problem is that patches seem to be against ide-2.6.git/for-next...

Sh*t, this is hitting the broken buffer allocation that Tejun removed
(I'm getting the same OOM-kill as the one Tejun's mentioning here
http://marc.info/?l=linux-ide&m=124191711928890) so even with those
patches, ide-tape is still broken.

I'm guessing backport all of Tejun's ide-tape cleanup stuff after Linus
pulls them into 31-rc1?

-- 
Regards/Gruss,
    Boris.
