Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYCCQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYCCQlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYCCQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:41:39 -0500
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.201.235]:24705 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753848AbYCCQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:41:38 -0500
X-Yahoo-Newman-Id: 846911.77333.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=mT/unCDtJBtvFovOldMq35Mml9pSqEk6V99TStkpaSo85o1rYv5oY/ccn30hSPLmMljuo/7GBjxDO3FK/TKRwAxg9C0p6Vqdjeq7xcGIChDc9xpmaZOvOE5zIvNm3PmYzwYcYnia08uTsyR2E13bGAhaE1ekVa5k6i/uHzyYRM0=  ;
X-YMail-OSG: D654UzYVM1m_.9Ng81MvWEF1dXMGxipTlIeWagqsTXkUyCGOlPClbxn0LLrYUzNzZ72qCyhFGw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: 2.6.24-sha1: RIP [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Tue, 4 Mar 2008 03:41:27 +1100
User-Agent: KMail/1.9.5
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <200803031538.35271.nickpiggin@yahoo.com.au> <4d569c330803030530j76a47249ic4e3eb2d86283d6f@mail.gmail.com>
In-Reply-To: <4d569c330803030530j76a47249ic4e3eb2d86283d6f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803040341.28127.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 00:30, Kevin Coffman wrote:
> On Sun, Mar 2, 2008 at 11:38 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
> >  Hmm, thanks for testing... Could it be caused by other bugs introduced
> >  in the kernel you are testing? Is the failing test using writev to
> >  write the file? Do you have any indication of the pattern of corruption?
>
> Well, all I did was apply your patch and re-run the same tests I've
> been running successfully.   (I'm still sitting at 2.6.25-rc1 right
> now).  Sorry, I don't have details about the corruption.  I'm home
> sick today, but I'll try to get more details when I get back in the
> office.

OK my last patch had a silly thinko in it, sorry. I'll improve it
and retest it before asking you to do any more. Thanks so far..

