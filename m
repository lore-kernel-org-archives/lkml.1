Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbXJCEgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbXJCEgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXJCEgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:36:38 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35500 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751050AbXJCEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:36:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eKt4TahtIU2w9UfASiONS7cfknsyvpaufIo3JwFh8cMhu6EvwsToZia/6aa9Q0FghK8JE+JXEoQwrfszI3NZo0jsHFC1VrDDDfUKE4DZ8W6lWrq9HcEK03myAnaGWGahx2nksK/o7+mE2eAwcSpx7MPgy4EM6VC8j4dyy+N0ViU=  ;
X-YMail-OSG: J0MO4jgVM1n.qy0iRum7h9p7AHLMuCsoP05FXiaz_LKnrPNlC7Uee3B.knY0TumCZ7BaGcgzeQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Date: Tue, 2 Oct 2007 22:05:04 +1000
User-Agent: KMail/1.9.5
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com> <1191325226.13204.63.camel@twins>
In-Reply-To: <1191325226.13204.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022205.05295.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 21:40, Peter Zijlstra wrote:
> On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:

> > How about adding this information to the tree then, instead of
> > creating a new top-level hack, just because something that you think
> > you need doesn't exist.
>
> So you suggest adding all the various network filesystems in there
> (where?), and adding the concept of a BDI, and ensuring all are properly
> linked together - somehow. Feel free to do so.

Would something fit better under /sys/fs/? At least filesystems are
already an existing concept to userspace.
