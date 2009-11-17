Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZKQLPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZKQLPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZKQLPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:15:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:24034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZKQLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=EYs4h/bpNslAcvbU5RRPJQK+8m/tlNqVPWrbNwmG8/LFayUBJKUUFuJ5fxlq7pctpE
         Fg4sO0CEORQjeLt4/nBQdRXXMJGO39CtDU8IzlhFQeFqCOhz40vMsJ0phCzwQKLeCAhq
         B79hJ6SJJnTmsR8FCb+tUda8OAUmsLfPQD7Yk=
Date: Tue, 17 Nov 2009 11:14:54 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: huananhu@huawei.com, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
Message-ID: <20091117111454.GA8341@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0278D9.6030806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-11-2009 11:20, William Allen Simpson wrote:
> David Miller wrote:
>> Your patch is broken, please don't wate my time like this.
>>
>> + git apply --check --whitespace=error-all diff
>> error: patch failed: drivers/net/ppp_async.c:36
>> error: drivers/net/ppp_async.c: patch does not apply
>>
> What David may have meant, had he followed Documentation/ManagementStyle
> or had any project management skills what-so-ever, is that you need to
> follow Documentation/SubmittingPatches more carefully.

I think this time it was only about a missing tab ;-)

Jarek P.

> 
> Look at 15) The canonical patch format
> 
> [PATCH 17/11] makes no sense, you don't have 11 patches, and the 17th
> patch of 11 can never exist.
> 
> Need a better "subsystem: summary phrase", perhaps
>    "net: PPP buffer too small for higher speed connections"
> 
> A marker line containing simply "---".
> 
> And your trailer boilerplate badly breaks the system, because it's
> missing the SMTP email standard "--" line in front of it.
> 
> You'll get nicer formatting with 'git format-patch -o ~ HEAD~1' after you
> do a 'git commit -a' on your git tree.
> 
> It takes some time, even for a simple 1 line fix like this....
> 
> Hope that helps.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



