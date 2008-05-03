Return-Path: <linux-kernel-owner+w=401wt.eu-S936711AbYECALo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936711AbYECALo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764994AbYECALe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:11:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24452 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764968AbYECALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IKPoW+VuDcyjoD5UDkcbOgP36Jg1owPXtXcjLoh3nclm9xNf9v6pa+47G+Q3NpoS/91VO+TZ10khhlWJffZ4ane9pBYyp9Yw0wLnlnDKFSIsw2CAygzKKE2genac1xGB5z9xSO4k3vyu68Op8G+siECSh03Mo2B+9LaQlPhcrjA=
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080502170802.456493a5.akpm@linux-foundation.org>
References: <1209754916.26173.39.camel@brick>
	 <20080502.162515.14823435.davem@davemloft.net>
	 <20080502163131.a13c0774.akpm@linux-foundation.org>
	 <1209772363.26173.101.camel@brick>
	 <20080502170802.456493a5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 17:11:56 -0700
Message-Id: <1209773516.26173.108.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 17:08 -0700, Andrew Morton wrote:
> On Fri, 02 May 2008 16:52:43 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > On Fri, 2008-05-02 at 16:31 -0700, Andrew Morton wrote:
> > > On Fri, 02 May 2008 16:25:15 -0700 (PDT)
> > > David Miller <davem@davemloft.net> wrote:
> > > 
> > > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > > Date: Fri, 02 May 2008 12:01:56 -0700
> > > > 
> > > > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > > 
> > > > Acked-by: David S. Miller <davem@davemloft.net>
> > > > 
> > > > This has to go in via who ever adds the first patch
> > > > with the actual helpers, so I won't apply this one.
> > > 
> > > Yup.  After a bit of testing and tyre-kicking I'll probably slip
> > > lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> > > trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> > > various maintainers.
> > > 
> > 
> > I suppose the hex_asc array and hex_to_int could also use
> > EXPORT_SYMBOL().
> 
> gack.  How could you do all those patches without discovering this?  Please
> go give your QA staff a wedgie.

allyesconfig :(

> > 
> 
> yes, hex_to_u8() is more specific and better defined than hex_to_int().
> 
> Although anally it should perhaps be two_digit_hex_to_ulong,
> four_digit_hex_to_ulong, etc.
> 
> ho hum, I'll drop them all.

My apologies, how about:

int hex_char_to_int(char ch)
int hex_char_to_int(char ch)
int hex_char_to_int(char ch)

EXPORT_SYMBOL(hex_dump_to_buffer);




