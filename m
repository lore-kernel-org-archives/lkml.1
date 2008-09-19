Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYISIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYISIBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYISIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:00:57 -0400
Received: from mail.cavein.org ([66.245.249.51]:49289 "EHLO mail.cavein.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYISIA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:00:56 -0400
X-DKIM: Sendmail DKIM Filter v2.6.0 smtp.cavein.org m8J80hRF015092
X-DomainKeys: Sendmail DomainKeys Filter v1.0.0 smtp.cavein.org m8J80hRF015092
DomainKey-Signature: a=rsa-sha1; s=2008; d=cavein.org; c=nofws; q=dns;
	h=date:from:to:cc:subject:in-reply-to:message-id:references:
	user-agent:mime-version:content-type;
	b=mTMRIqxkWUxmkuIcT0QuDzEmU2G2r/YMzKiM0MSzv90D27//bo49voBOHfvRgjOwp
	7x1uesfv9wI+kl5IKJnGuujBvKOh05PJpQ1WHN9FKMrHYsOCipE6JJ09txsPmFWTVNW
	sKB7Nm/H9zDBSAaMo/h3qWghLPiNQQGN7B46B2s=
Date: Fri, 19 Sep 2008 01:00:43 -0700 (PDT)
From: Richard A Nelson <cowboy@cavein.org>
To: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
cc: linux-kernel@vger.kernel.org
Subject: Re: NFS root + iptables in 2.6.25
In-Reply-To: <48D3451D.1080807@dgt.com.pl>
Message-ID: <alpine.DEB.2.00.0809190057200.14395@hygvzn-guhyr.pnirva.bet>
References: <48D3451D.1080807@dgt.com.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (smtp.cavein.org [127.0.0.1]); Fri, 19 Sep 2008 08:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008, Wojciech Kromer wrote:

> # modprobe iptable_nat
> nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> nfs: RPC call returned error 1
>
> Probably iptables changed it's default behavior from "allow all" to
> "deny all" at startup.
> Is there any way to change it back?
> I can't change anything after loading any iptable module, because all
> programs on filesystem are not accessible after loading...

NFS and iptables definitely takes some care - and there are still holes
- no way to specify ports for all requests...

but this seems odd...  you must've had some extant rules that suddenly
seemingly changed behaviour before the modprobe was done


-- 
Rick Nelson
[In 'Doctor' mode], I spent a good ten minutes telling Emacs what I
thought of it.  (The response was, 'Perhaps you could try to be less
abusive.')
 		-- Matt Welsh
