Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYLKAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYLKAdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYLKAdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:33:16 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:58527 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYLKAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=bffey07p53aeGQj2RVQzilnqkvP+vfL+d+5dzy2UenJEWhfRKn1Mc0mvK9JrzuFnG0
         Ea8x5o1EktkTb22acqqZHseTVFmZeeS45umQ3J34tZF1Lnp6AZ7PfQqIBNVV5R0SvJgj
         mf1hNRdGFX+QbnNvj/gNOd+yMqLCiTFAEQWbg=
Message-ID: <2c0942db0812101633o614390b0ob26e0d83ab78f0cf@mail.gmail.com>
Date: Wed, 10 Dec 2008 16:33:12 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Task Struct From Hell" <taskstructfromhell@googlemail.com>
Subject: Re: linux rebooting w/o crash dump
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <ef37ea20812101625u38af0b42q6a23246bc3eb803@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef37ea20812101623g52a36179g7924683d492e7fa7@mail.gmail.com>
	 <ef37ea20812101625u38af0b42q6a23246bc3eb803@mail.gmail.com>
X-Google-Sender-Auth: e10fae42df6969fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 4:25 PM, Task Struct From Hell
<taskstructfromhell@googlemail.com> wrote:
> Is there any way to debug a kernel that shuts down without leaving any
> sign of crash, shutdown demand or anything else?
>
> I am absolutely sure it's not a power issue, as I am running
> multi-boot and it's never shutting down on my other OSes,

That means nothing. Linux could be improperly driving the fans or
processor, and the board may be going into thermal shutdown. It
wouldn't be a hardware problem, but rather the kernel causing one.

> plus, with a
> newer kernel everything works like a charm - even with the flag
> 'noreboot'.

Confused. You mean a newer linux kernel doesn't show the problem?
Please explain?

> I would seriously love to find the root of this problem,
> but I'm feeling slightly hand-tied on it, been seeking for hints and
> trying different configurations for about 2 weeks...
