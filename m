Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYEESQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYEESQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYEESQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:16:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:11490 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYEESQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DoQq9p5rTHXgU8PfUeTYJRnAtrTiml/prYv7mznds9MC8ro7GLvaBt39kJBuCJGgsre8MSpEBouL16HQtbfOnQwfithogNgtr2kTtmFKore+yU7K+BjQXlZHuQ5zGjgipFMeZf6LaM/EWvlyzBWExO1j+Z/Fkzadf1JWnCgqQ9A=
Message-ID: <84144f020805051116mdbbea01q39f17bce95c95dbb@mail.gmail.com>
Date: Mon, 5 May 2008 21:16:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: git trees which are not yet in linux-next
Cc: linux-next@vger.kernel.org, "Steven French" <sfrench@us.ibm.com>,
       "Steven Whitehouse" <swhiteho@redhat.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jeff Garzik" <jeff@garzik.org>, "Ralf Baechle" <ralf@linux-mips.org>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>, "Jan Kara" <jack@ucw.cz>,
       "Anton Vorontsov" <cbou@mail.ru>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Eric Van Hensbergen" <ericvh@gmail.com>,
       "Wim Van Sebroeck" <wim@iguana.be>,
       "Christian Zankel" <chris@zankel.net>, "Nicolas Pitre" <nico@cam.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080502151206.b40f77ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
X-Google-Sender-Auth: df917cf2879bf0dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, May 3, 2008 at 1:12 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>  Guys, could you please prepare a tree for Stephen and send the details
>  over to him?  Please Cc me also.
>
>  Once this has happened, there should be no need to run a separate for-mm
>  branch.  I'll just switch over to using whatever branch linux-next is
>  using.

I was looking at preparing a for-next branch for the SLAB tree but I'm
not sure I understand the above. For something like the slab
allocator, you want as much exposure as possible before asking Linus
to pull so I would like to continue to (ab)use -mm for testing as
well. But that doesn't seem to fit the linux-next rules at all...

So what to do here? I don't have a problem with maintaining separate
branches for mm and next where the latter is not going to get much
action until very late in the release cycle when I'm preparing for the
next merge window.

                        Pekka
