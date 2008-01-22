Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYAWBA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYAWBA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYAWBAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:00:21 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:37220 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751683AbYAWBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:00:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iOd4Hy0q703tEvVAgUFsZ1k/TzJSUtTgu8pobFd1OGP6rygmcTXMAsE7foDC6ze4SVUobqL/kdHw5YrYlTMZIHtnW34QvySO3dwwdzIqiuhiUUfFtJ5GDoPbJh9zNHE6OGK1k+IvSSMIrxbCm+N56ptXLcOF82EfqyI6d/uwWfw=  ;
X-YMail-OSG: Tz6eRgIVM1nx_czcjZZan6VIWaWpz2Z6ETv9heZjChdydZnLmXoDw0S7oh6LtiTgwP8hdtxPKPXGKaa3E4lIUiSDxg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Wed, 23 Jan 2008 10:00:29 +1100
User-Agent: KMail/1.9.5
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <200801221105.11413.nickpiggin@yahoo.com.au> <20080122103708.GA21149@elte.hu>
In-Reply-To: <20080122103708.GA21149@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231000.30020.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 21:37, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Well I've twice tried to submit a patch to print stacks for running
> > tasks as well, but nobody seems interested. It would at least give a
> > chance to see something.
>
> i definitely remembering having done this myself a couple of times (it
> makes tons of sense to get _some_ info out of the system) but some
> problem in -mm kept reverting it. I dont remember the specifics ... it
> was some race.

Hmm, that's not unlikely. But there is nothing in the backtrace code
which prevents a task from being woken up anyway, is there? I guess
it will be more common now, but if we find a race we can try to fix
the root cause.
