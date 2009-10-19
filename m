Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZJSPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZJSPkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZJSPkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbZJSPkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:40:51 -0400
Date: Mon, 19 Oct 2009 17:36:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anirban Sinha <ani@anirban.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: Kernel oops when clearing bgp neighbor info with TCP MD5SUM
	enabled
Message-ID: <20091019153618.GA20967@redhat.com>
References: <Pine.LNX.4.64.0910081514050.18315@sleet.zeugmasystems.local> <20091008.155429.02850661.davem@davemloft.net> <Pine.LNX.4.64.0910081622400.18315@sleet.zeugmasystems.local> <20091008.175703.83006470.davem@davemloft.net> <Pine.LNX.4.64.0910171035340.2364@sleet.zeugmasystems.local> <4ADA7EDC.5010402@anirban.org> <4ADB7856.7000803@anirban.org> <20091019121327.GA11423@redhat.com> <4ADC8677.7000607@anirban.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADC8677.7000607@anirban.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Anirban Sinha wrote:
>
> Once upon a time, like on 09-10-19 5:13 AM, Oleg Nesterov wrote:
>
> >> Is is
> >> it illegal to schedule a work function from within a timer callback?
> >
> > Yes sure.
>
> hmm. may be in that case, that function needs to be re-written.

OOPS!!!! I misread your question, didn't notice "il" above...

I meant: yes sure it _is legal_ to schedule a work from within a timer
callback (in fact it is legal from any context).

Sorry for confusion.

Oleg.

