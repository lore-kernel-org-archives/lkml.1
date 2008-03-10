Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYCJSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYCJSW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYCJSWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:22:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYCJSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:22:48 -0400
Subject: Re: 2.6.25-rc4 todays: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000138
From: Peter Zijlstra <peterz@infradead.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <c4e36d110803100928o34e8cfa6o3087631f88762b7a@mail.gmail.com>
References: <c4e36d110803100928o34e8cfa6o3087631f88762b7a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 19:22:42 +0100
Message-Id: <1205173362.8514.155.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 17:28 +0100, Zdenek Kabelac wrote:

> I've got new oops today inside my qemu:
> (please check my comment about tainted bellow)
> 
> [   66.252118] p: module license 'unspecified' taints kernel.
> 
> [ 1935.986421] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000138
> 
> [ 1935.986421] IP: [<ffffffff8102e847>] pick_next_task_fair+0x37/0x60

Could you try with:

http://lkml.org/lkml/2008/3/10/199

