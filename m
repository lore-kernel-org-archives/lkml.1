Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYIHXci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYIHXci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYIHXc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:32:29 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43181 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754107AbYIHXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:32:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QNSgGWiQS/cEvhaG+DFS8bKmnSTOgluWyGUILWWjhAV5Ekmq4+VAhb/rNBBXvjzf27U8UZAhnXvY68+Mr8S45nhDOo8dBZrSq0OUpMs0TaUUUXzUU4Eq+cJFqu9AW3c4X4ZmrRoqq9dp34Hiiz7AR+e1OgoFFNDBl8g0FdTdznk=  ;
X-YMail-OSG: uJZq_C0VM1nKEwiscaOiuowztwKjXXqZJD_IcaigoIjD.yvlf1DJEhR5qWSFBdtT6CVbhqLDbS_nzFlEXyj8ySXfMTICiAOosa_joqiUsx3L5Jw9BKVzeCE1CLk964QbfXs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 16:32:25 -0700
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
References: <200809081429.57805.david-b@pacbell.net> <20080908.160441.124972717.davem@davemloft.net> <1220916186.8074.84.camel@localhost.localdomain>
In-Reply-To: <1220916186.8074.84.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809081632.26166.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, James Bottomley wrote:
> 
> > All the powerpc folks are doing is providing a dummy shim into the
> > RTC layer using their machine description vector, and not really using
> > the RTC layer drivers at all.
> 
> But realistically that's all we need.  Our RTC is controlled by two
> calls into firmware: a get and a set; nothing else.  We don't have the
> docs to get at the clock without the firmware calls.

True for PARISC ... but not for PowerPC.  Lots of PowerPC
system boards use off-the-shelf RTCs with more capabilities
than the machine description vector acknowledges.

- Dave

