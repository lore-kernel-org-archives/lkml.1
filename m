Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYCJTcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYCJTcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYCJTcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:32:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:60043 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYCJTcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FLLG+QT3fgVgQZRLL+CIS4xoiTtKj/Zpg9aN1JUJBK6gnRgBFxFjZblS52dUzAY9CWp+mxvtCagf8C9W5xPMqfoWWJ619deEEQI/ZsYT8NjCpwGTCSviVaCzkGFCGrZPXh2aBzivX+hF6CpIg4YUfdwNg8XpOPVGrMz7nnfv/GM=
Message-ID: <c4e36d110803101231n97aec1haf6c663d9925b60f@mail.gmail.com>
Date: Mon, 10 Mar 2008 20:31:59 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: 2.6.25-rc4 todays: BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1205173362.8514.155.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110803100928o34e8cfa6o3087631f88762b7a@mail.gmail.com>
	 <1205173362.8514.155.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/10, Peter Zijlstra <peterz@infradead.org>:
> On Mon, 2008-03-10 at 17:28 +0100, Zdenek Kabelac wrote:
>
>  > I've got new oops today inside my qemu:
>  > (please check my comment about tainted bellow)
>  >
>  > [   66.252118] p: module license 'unspecified' taints kernel.
>  >
>  > [ 1935.986421] BUG: unable to handle kernel NULL pointer dereference
>  > at 0000000000000138
>  >
>  > [ 1935.986421] IP: [<ffffffff8102e847>] pick_next_task_fair+0x37/0x60
>
>
> Could you try with:
>
>  http://lkml.org/lkml/2008/3/10/199

yes - already noticed and testing - one thing I could say for sure is
- it has not fixed my busy loop problem with clearing of vmalloced
memory inside qemu.
Let's see if I'll ever get my oops problem...

Zdenek
