Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYKUTH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYKUTH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYKUTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:07:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYKUTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:07:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=S/XQ1qEu0T3fSJwNh202Wz5ilfG0Nf7e07xK1MnuYWVFEuUlJhoNPXHJZSgAoTLxa
	QY8Wb9g270AkiFTOMQrEw==
MIME-Version: 1.0
In-Reply-To: <6599ad830811211105p711aebc3v85ffffbc399bdd6e@mail.gmail.com>
References: <49267624.70305@cn.fujitsu.com>
	 <6599ad830811211105p711aebc3v85ffffbc399bdd6e@mail.gmail.com>
Date: Fri, 21 Nov 2008 11:07:10 -0800
Message-ID: <6599ad830811211107n141e6cb5n2abf14e59110d764@mail.gmail.com>
Subject: Re: [PATCH] cpuset: rcu_read_lock() to protect task_cs() even we 
	don't dereference to task_cs()'s return value
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 11:05 AM, Paul Menage <menage@google.com> wrote:
>
> Wouldn't this be fixed by your patch that adds an rcu_read_lock() to
> task_subsys_state() ?
>

Sorry, your other patch actually adds the rcu_read_lock() to
task_cgroup(). But adding an rcu_read_lock() to task_subsys_state()
would also help here.

Paul
