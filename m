Return-Path: <linux-kernel-owner+w=401wt.eu-S937062AbYEUTrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937062AbYEUTrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbYEUTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:47:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:54835 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbYEUTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vk5bw3BrXMLiLt1d+sViSOeZkpdP/yDGx0BhWtbo/QlVd7GxvZZCXhlhnv9AEZ2h0MOLMUGRf2kMHgzmGuRvE819VRvUo+U8KZW8Xppf18KSp6L9RwHpeMUKIPTpB36OapQM0p7raGaejZpRruvBcSBtN8tXBCiQHIVPgw+U7zQ=
Date: Wed, 21 May 2008 23:47:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521194716.GB13916@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <87ej7v4f6f.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ej7v4f6f.fsf@saeurebad.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Johannes Weiner - Wed, May 21, 2008 at 09:42:32PM +0200]
| Hi,
| 
| Cyrill Gorcunov <gorcunov@gmail.com> writes:
| 
| > [Andrew Morton - Wed, May 21, 2008 at 10:46:44AM -0700]
| > | On Wed, 21 May 2008 08:09:39 -0400 Theodore Tso <tytso@mit.edu> wrote:
| > | 
| > | > On Wed, May 21, 2008 at 06:32:06AM -0400, Christoph Hellwig wrote:
| > | > > On Wed, May 21, 2008 at 01:50:37AM -0700, Andrew Morton wrote:
| > | > > > Oh, what a marvellous way to encourage new contributors that was. Thank
| > | > > > you so much.
| > | > > > 
| > | > > > For the record: Al speaks only for himself and a lack of expressed
| > | > > > disagrement from others should not be taken as agreement.
| > | > > 
| > | > > But I'd like to second the opinion.  This is getting a little too far.
| > | > > We should rather try to at least enforce very basic standards a lot of
| > | > > the crap shoved in doesn't follow instead of wanking around about exact
| > | > > placement of whitespaces.
| > | > 
| > | > The real question is whether people who are wanking about whitespace
| > | > and spelling fixes in comments will graduate to writing real, useful
| > | > patches.  If they won't, there's no point to encouraging them.
| > | > 
| > | 
| > | Guys, get a clue.  It doesn't matter what that person did.  It is the
| > | effect upon *all* other potential developers which is so damaging here.
| > | Not upon this individual.
| > | 
| >
| > Btw, we have CodingStyle, SubmittingPatches and other, but why don't
| > we have something like KernelNewbieGuide? Don't get me wrong, but
| > there could be written all rules about - what is good to do, what is bad.
| > So a newbiew who wants to be usefull for kernel could read it and decide
| > what should be done. /Don't beat me ;) / And of course I know about
| > kernelnewbie.org but this (even quite short) document could help I
| > think.
| 
| How about the following?
| 
| ---
| 
| From: Johannes Weiner <hannes@saeurebad.de>
| Subject: [PATCH] CodingStyle: no more trivial coding style fixes, please
| 
| Add a note to CodingStyle that style cleanups should only be done if the
| code is really offending and violating the kernel conventions heavily.
| But no more oneliners fixing indentation and the like.
| 
| Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
| ---
| 
|  Documentation/CodingStyle |   12 ++++++++++++
|  1 file changed, 12 insertions(+)
| 
| --- a/Documentation/CodingStyle
| +++ b/Documentation/CodingStyle
| @@ -783,6 +783,18 @@ own custom mode, or may have some other 
|  work correctly.
|  
|  
| +		Chapter 19:  No coding style patches, please
| +
| +While all these conventions should be honored when writing new code
| +please do not send patches that fix minimal coding style issues only.
| +
| +If a whole file or several logically connected ones are in a really
| +bad shape (i.e. violating several points named here), a patch cleaning
| +them up in one go is okay.
| +
| +But do not send patches that fix indentation of two lines.  It is not
| +worth the effort.
| +
|  
|  		Appendix I: References
| 

I liked it, really. Thanks!

		- Cyrill -
