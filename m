Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZJGHb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZJGHb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbZJGHb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:31:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:51150 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653AbZJGHb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gN0IQtWBhSXIcWee6MtszZa5Ja1fDNRwRUAQ8cCRLNtCyI7sIioxFFh9wb8oQnMF1o
         qCUj/V7rJMmid77MO/vdS/CtAXa56DLOXjlrzb8tdvWOPkGN2aZ83T3L7Z5MZx1T1ek6
         LnjS4ZS0/KwF7sbyrCUq70VA4sP4BgZXBNlTE=
MIME-Version: 1.0
In-Reply-To: <20091007061223.GA17794@helight>
References: <20091007061223.GA17794@helight>
Date: Wed, 7 Oct 2009 15:30:50 +0800
Message-ID: <2375c9f90910070030u3ee74d5csf81ff6d93a207c50@mail.gmail.com>
Subject: Re: [PATCH] fix two warnings on mm/percpu.c
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 2:12 PM, Zhenwen Xu <helight.xu@gmail.com> wrote:
> fix those two warnings:
>
> mm/percpu.c: In function ‘pcpu_embed_first_chunk’:
> mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
> mm/percpu.c:1879: warning: format ‘%lx’ expects type ‘long unsigned int’, but
> argument 2 has type ‘size_t

It is fixed:

http://patchwork.kernel.org/patch/51565/
