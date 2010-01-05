Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404Ab0AET2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0AET2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675Ab0AET2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:28:49 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44942 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0AET2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=je3QZTsV4ESmaexObmvG19Bq6yMsDc3i0DoN6j7JMo0OahGdokRDrllU4jg10BZb63
         cllD4l1qKk7CmVQtYLUC0tr2ZR8fsXrx1JZILDXgedLhZHbGMSyW6or+XK7l8zPs2m1o
         IWgLoJgs2E6S3IpAegyYgKueQU4FfkPBJJVKE=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909291944q53a060buc7bcbb30c1240da7@mail.gmail.com>
References: <1254133004-24877-1-git-send-email-21cnbao@gmail.com> 
	<8bd0f97a0909291944q53a060buc7bcbb30c1240da7@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 5 Jan 2010 14:28:27 -0500
Message-ID: <8bd0f97a1001051128s272f9881q4f1418eba08f1478@mail.gmail.com>
Subject: Re: [PATCH] Fix half-Y2K38 problem in timecompare_update while 
	calculating offset
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, patrick.ohly@intel.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 21:44, Mike Frysinger wrote:
> On Mon, Sep 28, 2009 at 06:16, Barry Song wrote:
>> ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
>> ktime_add() in timecompare_update() will overflow a half earlier.
>> As a result, wrong offset will be gotten, then cause some strange
>> problems.
>
> Barry: you forgot to include your s-o-b tag ...

you still need to post your s-o-b if we want this to go any further
-mike
