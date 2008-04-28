Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbYD1N2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbYD1N2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763103AbYD1N14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:27:56 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:5046 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762680AbYD1N1z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:27:55 -0400
Date: Mon, 28 Apr 2008 14:27:51 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Sergio Luis <sergio@larces.uece.br>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 slow boot/reboot
Message-ID: <20080428132751.GA11256@deepthought>
References: <48141111.7010605@larces.uece.br> <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com> <20080427235554.GA28344@deepthought> <e2e108260804272310r7aa99a91x204aeac5418fb25e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <e2e108260804272310r7aa99a91x204aeac5418fb25e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 08:10:10AM +0200, Bart Van Assche wrote:
> On Mon, Apr 28, 2008 at 1:55 AM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> >   But, I think you (Bart) haven't said which version of lilo you are
> >  using ?  If it isn't recent, perhaps upgrading it might help ?
> 
> I noticed the slow loading behavior of LILO after a fresh install of
> Ubuntu 8.04 beta with XFS as root file system. I did not check the
> version number. Should I look it up ?
> 
> Bart.

 '/sbin/lilo -V' but a look at their pool implies it will either be
22.8 or 22.6.  A quick look at the changelog in their diff for 22.8
shows they are using device-mapper, dunno if that has any relevance to
this problem.

Ken
--
das eine Mal als Tragödie, das andere Mal als Farce
