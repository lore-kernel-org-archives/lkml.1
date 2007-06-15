Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbXFOPEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbXFOPEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXFOPEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:04:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:45153 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXFOPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D/BVYHcByOaIWkSTsuygMrLkh8OHRUp8g3ol3aBgrAst4igoiu2HRaoohpHnK/e+5u8Yg1VDH81WwHiAhX/h0nPw90L1EMMLTZ4LnOrb6BpXzKy98Y2GkWPne7sWkMSmH8gpI8iWQxMHJxA9d9e4aotzDN71jgvd5pfXw0zzjdM=
Message-ID: <19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
Date: Fri, 15 Jun 2007 17:04:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: How to printk unsigned long long variable?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> typedef unsigned long long u64;
> u64             *dma_mask;
> Then how to use printk() to print out a dma_mask variable?

In regular printf(), this would be specified by the format "%llu". Try that?

Vegard
