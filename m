Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYJKPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYJKPJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYJKPJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:09:46 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:60054 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYJKPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:09:45 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Philip Stark" <heller.barde@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 seems to break something with DSL
Date: Sun, 12 Oct 2008 02:09:43 +1100
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <b6g1f4dkve11bscth3mon86fagchkqb76m@4ax.com>
References: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
In-Reply-To: <c6740f810810110553q75478033ub984651d5509199b@mail.gmail.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 14:53:16 +0200, "Philip Stark" <heller.barde@gmail.com> wrote:

>Hi,
>
>I'm sorry, I didn't lurk before making my first posting to this list,
>but it seemed to me that this might be an important problem/bug (if it
>is one).
>
>first off, my network infrastructure:
>
>"internet" --(magic*)-- DSL Modem --(DHCP)-- Router --(DHCP)-- Computer
>* PPPsomething i guess...

Well I connect via rp-pppoe to a bridged ADSL modem.  One recent gotcha 
is that iptables userspace has to be updated to match the latest kernel, 
how old is your distro?  What version iptables?  Last I checked 1.4.1.1 
was latest available from netfilter.org.

>but i can't browse. that is when i 'wget kernel.org' it resolves the
>address into the correct IP and then goes on to 'connecting' just to
>grind to a complete halt. after some time of course it times out.

This could be due to your firewall rules?  More people would have 
noticed if their networking died ;)  (Unless you're running a e1000, all 
bets off).

Grant.
