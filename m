Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbXESTUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbXESTUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXESTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:20:28 -0400
Received: from 1wt.eu ([62.212.114.60]:2689 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbXESTU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:20:27 -0400
Date: Sat, 19 May 2007 21:20:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: it seems at XFS bug?!
Message-ID: <20070519192021.GK943@1wt.eu>
References: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com> <E1HpUNW-00020n-00@calista.eckenfels.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HpUNW-00020n-00@calista.eckenfels.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 09:14:10PM +0200, Bernd Eckenfels wrote:
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

No, look closer above, its name is the single-character '\xa0'. It's
this output format which makes the analysis difficult. And it's also
'od' which has added '\0' to pad its 16 bit buffer. I tend to prefer
to use 'od -tx1' or 'od -ctx1' here.

I would suggest doing 'rm -i ?' to remove that file, or rm -i $'\xa0'
for the paranoid.

Willy

