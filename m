Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZHXJDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZHXJDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZHXJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:03:42 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:44833 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZHXJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=QgmGvsgksRmM2XLiVnL5mTIrdH2c2QkO
	daXTOScUK+E7iRCKckrNnnw78GUn9MCnlU2lfzT/XbtZ4wQvYv68cOoY4hM74stU
	FaN3hLpe+NVnKqJzChnvdLdUAhe3nSUDNltmHz2T997zWAhBDLZobOD85UHKoprT
	NuUQMeuVv8M=
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/6] Lazy workqueues
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com>
 <1250769861.8282.182.camel@twins> <20090820120858.GJ12579@kernel.dk>
 <1250770571.8282.186.camel@twins> <7vfxbj1car.fsf@alter.siamese.dyndns.org>
 <20090824080429.GC12579@kernel.dk>
From: Junio C Hamano <junio@pobox.com>
Date: Mon, 24 Aug 2009 02:03:23 -0700
In-Reply-To: <20090824080429.GC12579@kernel.dk> (Jens Axboe's message of
 "Mon\, 24 Aug 2009 10\:04\:29 +0200")
Message-ID: <7veir1lh2c.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 0087D2DE-908D-11DE-B4B0-CA0F1FFB4A78-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> OK that's at least something, looking forward to being able to prune
> that argument from my scripts.

Ahahh.

An option everybody will want to pass but is prone to be forgotten and
hard to type from the command line is one thing, but if you are scripting
in order to reuse the script over and over, that is a separate story.  Is
losing an option from your script really the goal of this fuss?

In any case, you not need to wait for a new version nor a patch at all for
that goal.  You can simply add

[sendemail]
	chainreplyto = no

to your .git/config (or $HOME/.gitconfig).  Both your script and your
command line invocation will default not to create deep threads with the
setting.


