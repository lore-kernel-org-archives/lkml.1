Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYFVJPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYFVJPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYFVJO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:14:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59686 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYFVJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:14:57 -0400
Date: Sun, 22 Jun 2008 11:14:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Smith <eric@brouhaha.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: Any lightweight way for one thread to force another thread to 
      suspend execution?
In-Reply-To: <49370.71.139.37.220.1214099737.squirrel@ruckus.brouhaha.com>
Message-ID: <alpine.LNX.1.10.0806221113490.15126@fbirervta.pbzchgretzou.qr>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>    <877iciyjcs.fsf@basil.nowhere.org> <49370.71.139.37.220.1214099737.squirrel@ruckus.brouhaha.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-06-22 03:55, Eric Smith wrote:
>Andi wrote:
>> Any such mechanism will need a syscall, and it's unlikely that
>> any syscall will get much cheaper than a kill(SIGSTOP)
>
>But is there a way for the process sending the SIGSTOP to wait until it
>has taken effect?  I need a method to *synchronously* stop another
>thread.  That's why I thought I probably needed something more
>elaborate than SIGSTOP, though I'd like to minimize the number of
>system calls required.

When it is stopped, the process state changes to "T" (in ps and /proc).
Note that debugging a program with gdb or ptrace also puts it in the T state.
