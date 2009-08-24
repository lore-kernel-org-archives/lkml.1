Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZHXJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZHXJMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZHXJMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:12:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44721 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZHXJMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:12:47 -0400
Subject: Re: [PATCH 0/6] Lazy workqueues
From: Peter Zijlstra <peterz@infradead.org>
To: Junio C Hamano <junio@pobox.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <7veir1lh2c.fsf@alter.siamese.dyndns.org>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
	 <1250769861.8282.182.camel@twins> <20090820120858.GJ12579@kernel.dk>
	 <1250770571.8282.186.camel@twins> <7vfxbj1car.fsf@alter.siamese.dyndns.org>
	 <20090824080429.GC12579@kernel.dk>
	 <7veir1lh2c.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 11:11:07 +0200
Message-Id: <1251105067.7538.147.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 02:03 -0700, Junio C Hamano wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > OK that's at least something, looking forward to being able to prune
> > that argument from my scripts.
> 
> Ahahh.
> 
> An option everybody will want to pass but is prone to be forgotten and
> hard to type from the command line is one thing, but if you are scripting
> in order to reuse the script over and over, that is a separate story.  Is
> losing an option from your script really the goal of this fuss?
> 
> In any case, you not need to wait for a new version nor a patch at all for
> that goal.  You can simply add
> 
> [sendemail]
> 	chainreplyto = no
> 
> to your .git/config (or $HOME/.gitconfig).  Both your script and your
> command line invocation will default not to create deep threads with the
> setting.

For me its about getting the default right, because lots of people
simply use git-send-email without scrips, and often .gitconfig gets lost
or simply doesn't get carried around the various development machines.

Also, it stop every new person mailing patches from having to be told to
flip that setting.
