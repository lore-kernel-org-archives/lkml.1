Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbXJYSp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbXJYSp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbXJYSph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:45:37 -0400
Received: from main.gmane.org ([80.91.229.2]:55260 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbXJYSpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:45:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 19:45:20 +0100
Message-ID: <yw1xwstbjanz.fsf@thrashbarg.mansr.com>
References: <200710251358.55185.nickpiggin@yahoo.com.au> <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com> <20071024213533.12115ba0@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87-194-163-22.bethere.co.uk
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:m8/DVLG5/NJnRMHYx20gK9qWZgs=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Wed, 24 Oct 2007 21:29:56 -0700
> "David Schwartz" <davids@webmaster.com> wrote:
>
>> 
>> > Well that's exactly right. For threaded programs (and maybe even
>> > real-world non-threaded ones in general), you don't want to be
>> > even _reading_ global variables if you don't need to. Cache misses
>> > and cacheline bouncing could easily cause performance to completely
>> > tank in some cases while only gaining a cycle or two in
>> > microbenchmarks for doing these funny x86 predication things.
>> 
>> For some CPUs, replacing an conditional branch with a conditional
>> move is a *huge* win because it cannot be mispredicted.
>
> please name one...
> Hint: It's not one made by either Intel or AMD in the last 4 years...

ARM.  On ARM1136 (used in the Nokia N800) a mispredicted branch takes
5-7 cycles (a correctly predicted branch takes 0-4 cycles), while a
conditional load, store or arithmetic instruction always takes one
cycle.

-- 
Måns Rullgård
mans@mansr.com

