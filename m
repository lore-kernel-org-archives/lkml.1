Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYAVAF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYAVAF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYAVAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:05:19 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:48588 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752994AbYAVAFS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:05:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pbP+X9XTwIhjgfQpC7Hq5ngDrqaeQKPHq/kXOAVxsrK6zJz4c9rT6CWWqEY/F3mF2XACS3s7vH4nvIITTtIK6N1kSe7Pkvzl6Z3wq+tNaLHxWypdII/7iA97LC2EWod1LQs4fjro4z51h5waAroj6eeY6W1bMuzub2jeSBEOxoY=  ;
X-YMail-OSG: MsaR7_AVM1lAKwk1KbePVoCHrnpS6OEG_AGjOlymyZ1ToKYgQvpHIPVhVa_4iCYAY_dNaBtBgA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Tue, 22 Jan 2008 11:05:11 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia>
In-Reply-To: <1200949086.6648.19.camel@Anastacia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801221105.11413.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> reader starts using 100% of CPU time after some time. When this happens,
> kill -9 does not work, and strace just hangs when trying to attach to
> the process. The same with gdb. ﻿ps shows the process as being in the R
> state.
>
> I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> Jan 21 21:45:01 Anastacia kernel: pan           R  running task        0 

Well I've twice tried to submit a patch to print stacks for running
tasks as well, but nobody seems interested. It would at least give a
chance to see something.

Can you post a few Sysrq+P traces?

