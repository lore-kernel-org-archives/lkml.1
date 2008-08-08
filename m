Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYHHLBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYHHLBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYHHLBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:01:23 -0400
Received: from saeurebad.de ([85.214.36.134]:57979 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYHHLBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:01:22 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Radical idea? Remove all automatic privilege escalation base on executable file attributes!
References: <87abfn94rs.fsf@burp.tkv.asdf.org>
Date: Fri, 08 Aug 2008 13:00:55 +0200
In-Reply-To: <87abfn94rs.fsf@burp.tkv.asdf.org> (Markku Savela's message of
	"Fri, 08 Aug 2008 13:31:51 +0300")
Message-ID: <877iar4vq0.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Markku Savela <msa@moth.iki.fi> writes:

> That is, remove
>
>  - setuid/setgid feature from Linux
>
>  - cancel the capability attributes in files (or only only allow
>    downgrading of capabilities)
>
> (e.g. mount everything as nosuid or something, but eventually, the
> code could be removed from the kernel)
>
> The only way to escalate privileges would be to request starting of
> the executable by some daemon (like upstart), which would grant or
> deny the request based totally on some user space policies.

Let's just hope then that this central facility is not buggy itself.
Because if that would be the only way to acquire privileges as
non-priviledged user, it is likely that every machine runs it.

Opposed to a bug in one setuid program that not everyone is even
garuanteed to have installed.

	Hannes
