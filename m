Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0CLFnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:43:19 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34009 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0CLFnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IhL+FADQNhhWDe6uCmML/baZW/01nPABz0kF24d29ilAnHT00GFWJ4vh6v/kxbc37O
         rZmsBBA+QbHwePNW6iRoXj/3PUjtfvYDcLh0k0vwFM7+4WlqGiOs8LChVez3aVWDt59r
         tFuCHyKO07bjvcqdoX2XF5jtdDY6dcuPRapdM=
Date: Fri, 12 Mar 2010 06:43:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Clark Williams <williams@redhat.com>,
       Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= 
	<lclaudio@redhat.com>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
Message-ID: <20100312054312.GA5014@nowhere>
References: <1268349164-5822-1-git-send-email-acme@infradead.org> <1268349164-5822-5-git-send-email-acme@infradead.org> <20100311232952.GF28421@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311232952.GF28421@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 08:29:53PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 11, 2010 at 08:12:44PM -0300, Arnaldo Carvalho de Melo escreveu:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Newt has widespread availability and provides a rather simple API as can be
> > seen by the size of this patch.
> > 
> > The work needed to support it will benefit other frontends too.
> > 
> > In this initial patch it just checks if the output is a tty, if not it falls
> > back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
> > the previous behaviour is maintaned.
> > 
> > Pressing enter on a symbol will annotate it, ESC in the annotation window will
> > return to the report symbol list.
> 
> For those not so curious as to apply and try it out, here is a
> screenshot of it in action:
> 
> http://tglx.de/~acme/perf-newt.png
> 
> :-)


Wow! Linking from perf report to perf annotate in a simple key
in a TUI, my dreams become true :-)

Sweet.

