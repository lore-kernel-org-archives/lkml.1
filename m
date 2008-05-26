Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYEZRHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYEZRHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYEZRHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:07:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYEZRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:07:43 -0400
Date: Mon, 26 May 2008 09:24:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526092407.76df09d7@infradead.org>
In-Reply-To: <20080526115628.GA31316@elte.hu>
References: <20080526115628.GA31316@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 13:56:28 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> in an overnight -tip testruns that is based on recent -git i got two 
> stuck TCP connections:
> 
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address               Foreign
> Address             State tcp        0 174592
> 10.0.1.14:58015             10.0.1.14:3632              ESTABLISHED
> tcp    72134      0 10.0.1.14:3632
> 10.0.1.14:58015             ESTABLISHED 
> 
> on a previously reliable machine. That connection has been stuck for
> 9 hours so it does not time out, etc. - and the distcc run that goes
> over that connection is stuck as well.
> 

interestingly enough, I think I'm seeing something very similar to this
with the claws email client; as of 2.6.26-rc3 (sorry, didn't run
earlier ones because they broke my wireless) claws gets "stuck" once in
a while, really stuck, when talking to the imap server.....
It seems to happen a little less frequently when running under strace,
but it still happens, so that could just be a timing thing.

