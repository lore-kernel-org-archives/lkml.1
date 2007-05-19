Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbXESTVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbXESTVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763713AbXESTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:20:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:3602 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbXESTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tztO6SEOXrwHbAplMs8G6tjK2DKyJLhTA7lGAuBzwF+CZaNBaZ5YZfcOzB5/tRGWjCGE6OtqyvruFG7VKTOkZOFqoGdZc1hrUcIFwLqcI8P6K79kQEIiuF3uue/RZd47rAMmjNPz040LYGoGh8Q7kJRo4FvpsuxD9XWgUaCfiYY=
Message-ID: <6101e8c40705191220y1c627dc0ydccabb0385c08c30@mail.gmail.com>
Date: Sat, 19 May 2007 21:20:54 +0200
From: "oliver pinter" <oliver.pntr@gmail.com>
To: "Bernd Eckenfels" <ecki@lina.inka.de>
Subject: Re: it seems at XFS bug?!
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com
In-Reply-To: <E1HpUNW-00020n-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com>
	 <E1HpUNW-00020n-00@calista.eckenfels.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

other dir's ls see I zero \0

On 5/19/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
> In article <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com> you wrote:
> > 0000500   8   6   1   2   5   4   9       -   r   w   -   r   -   -   r
> >        3638 3231 3435 2039 722d 2d77 2d72 722d
> > 0000520   -   -       1       r   o   o   t       r   o   o   t
> >        2d2d 3120 7220 6f6f 2074 6f72 746f 2020
> > 0000540                   0       2   0   0   7   -   0   5   -   0   6
> >        2020 2020 2030 3032 3730 302d 2d35 3630
> > 0000560       1   2   :   4   1          \n  \0
> >        3120 3a32 3134 a020 000a
> > 0000571
>
> That file with the inode 8612549 has indeed an empty name. (And I wonder a
> bit about the trailing \0, my ls does not do that?)
>
> Gruss
> Bernd
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
