Return-Path: <linux-kernel-owner+w=401wt.eu-S935052AbYCFQ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052AbYCFQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934749AbYCFQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:27:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:49644 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbYCFQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:27:18 -0500
Message-ID: <19e566510803060827u4c698f56l6c0faae71068588d@mail.gmail.com>
Date: Thu, 6 Mar 2008 18:27:15 +0200
From: "=?UTF-8?Q?=C4=B0smail_D=C3=B6nmez?=" <ismail@namtrac.org>
To: "Jakub Jelinek" <jakub@redhat.com>
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
       NightStrike <nightstrike@gmail.com>,
       "Olivier Galibert" <galibert@pobox.com>,
       "Chris Lattner" <clattner@apple.com>, "Michael Matz" <matz@suse.de>,
       "Richard Guenther" <richard.guenther@gmail.com>,
       "Joe Buck" <Joe.Buck@synopsys.com>, "Jan Hubicka" <hubicka@ucw.cz>,
       "Aurelien Jarno" <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
In-Reply-To: <20080306162353.GF24887@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
	 <47CF3F09.4080606@zytor.com>
	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
	 <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
	 <6dc9ffc80803060743h502fc96bj6117ef87a8555c3a@mail.gmail.com>
	 <47D012B4.3020104@zytor.com>
	 <20080306162353.GF24887@devserv.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 6, 2008 at 6:23 PM, Jakub Jelinek <jakub@redhat.com> wrote:
> On Thu, Mar 06, 2008 at 07:50:12AM -0800, H. Peter Anvin wrote:
>  > H.J. Lu wrote:
>  > >I agree with it. There is no  right or wrong here Let's start from
>  > >scratch and figure out
>  > >what is the best way to handle this, assuming we are defining a new psABI.
>
>  BTW, just tested icc and icc doesn't generate cld either (so it matches the
>  new gcc behavior).
>  char buf1[32], buf2[32];
>  void bar (void);
>  void foo (void)
>  {
>   __builtin_memset (buf1, 0, 32);
>   bar ();
>   __builtin_memset (buf2, 0, 32);
>  }

Also LKML discussion pointed out that Solaris gets this right too.

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
