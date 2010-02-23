Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab0BWO0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:26:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:39697 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0BWO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:26:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YrnewoiGLG4Rz7WAjiQ2MYWMLXmrOPZxsLvnJLJkwC8MZ23tOCfVGc5sZHYSUl10fM
         9We1gS8jcBLSMGUw+K+0tzI5OzESAQTfdavISVqeAoq/5OAGJTl/EG/KawY/mmTuilG2
         fixSgykwP13WS0D3IW/Awm4SmtFLqpYmf/a0E=
MIME-Version: 1.0
In-Reply-To: <20100223075527.GL1025@kernel.dk>
References: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com>
	 <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com>
	 <20100223075527.GL1025@kernel.dk>
Date: Tue, 23 Feb 2010 23:26:28 +0900
Message-ID: <961aa3351002230626g57bbe867gb01c936897dcfedd@mail.gmail.com>
Subject: Re: [PATCH] blk-core: use BIO list management functions
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/23 Jens Axboe <jens.axboe@oracle.com>:
> On Mon, Feb 22 2010, Akinobu Mita wrote:
>> Now that the bio list management stuff is generic, convert
>> generic_make_request to use bio lists instead of its own private bio
>> list implementation.
>
> Looks good, applied. Also saves 4 bytes in task_struct, not a bad thing
> :-)

Thanks.

How about another cleanup patch for pktcdvd?
http://lkml.org/lkml/2010/2/22/93
