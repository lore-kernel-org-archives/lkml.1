Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYH1Ap3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYH1Ap3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYH1ApN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:45:13 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:32215 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754004AbYH1ApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:45:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=35gRYWEeVYRek4h74mOVuWMgOMjFVko44zwdLe5rWPXRw3zA71XqCf4hBmDsWRMKfhIyNTvtm9zmUqrScK8Wv51FKlCBPRiexQWOD+7QkVKr9wFFGZR2KrWk2bf21L9iKScFU0JAHI7UB0ben/+gbiuHc7I1/L2A4X43z405tF8=  ;
X-YMail-OSG: iGXDKakVM1m58AxL_D7mpPINQi3xi4bo1n9KGwlnMCU3rk8SCERNopYmChObpUB6iNl_aqp8s8Js9H4_bTxUAe0nDj.uFlEDWtMT861dnSNtQhlMN5.N3fKCQrFFm2mIfadJ.riG9LXDJnIcy3X07oqK
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 10:45:03 +1000
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, rick.jones2@hp.com,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87vdxmr53f.fsf@basil.nowhere.org> <20080827.151824.14173512.davem@davemloft.net> <20080827223952.GE26610@one.firstfloor.org>
In-Reply-To: <20080827223952.GE26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281045.03460.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 08:39, Andi Kleen wrote:
> On Wed, Aug 27, 2008 at 03:18:24PM -0700, David Miller wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > Date: Wed, 27 Aug 2008 18:27:35 +0200
> >
> > > > Those banks really want to crank down on latency - to the point they
> > > > start disabling interrupt coalescing.  I bet they'd toss anything out
> > > > they could to shave another microsecond.
> > >
> > > This change would actually likely lower their latency.
> >
> > They want the timestamps, but they want it to match when the packet
> > arrived at their system as closely as is reasonably possible.
>
> Then they should use hardware time stamps which are increasingly
> available (e.g. current Intel e1000 design has them and I expect
> others too).

Would it make sense to make a new option for these socket timestamps
and encourage some apps move over to it?
