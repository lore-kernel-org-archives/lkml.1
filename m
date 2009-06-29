Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZF2RTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZF2RTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZF2RTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:19:36 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38588 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZF2RTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYjGllai6cJDh0QQq+g7OKwerMlvYY2zBdfVqJmnoX3Fu6HXr0iBMbfcHjWi1V0GsR
         hLGC/0LLo6LhFKMnHmE2QF5QQgQygbVZZy+p897E00Hvqp4/BtusbyyEWQEiNKVNUURf
         TG0QPp/dqCrEXBozZGMDh7CeVkiOdtf5Rc+yM=
Date: Mon, 29 Jun 2009 19:19:26 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
	callbacks
Message-ID: <20090629171926.GB2742@ami.dom.local>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 04:14:45PM +0200, Jiri Olsa wrote:
...
> +static inline void sock_poll_wait(struct file *filp, struct sock *sk,
...
> +	sock_poll_wait(file, sk->sk_sleep, wait);

-----------------------------^^^^^^^^^^^^
Is it something with my eyes or it wasn't compiled? ;-)

Jarek P.
