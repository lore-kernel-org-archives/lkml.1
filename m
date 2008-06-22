Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYFVBzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYFVBzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 21:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYFVBzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 21:55:43 -0400
Received: from ruckus.brouhaha.com ([64.62.206.2]:57678 "EHLO
	ruckus.brouhaha.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYFVBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 21:55:42 -0400
Message-ID: <49370.71.139.37.220.1214099737.squirrel@ruckus.brouhaha.com>
In-Reply-To: <877iciyjcs.fsf@basil.nowhere.org>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
    <877iciyjcs.fsf@basil.nowhere.org>
Date: Sat, 21 Jun 2008 18:55:37 -0700 (PDT)
Subject: Re: Any lightweight way for one thread to force another thread to  
     suspend execution?
From: "Eric Smith" <eric@brouhaha.com>
To: linux-kernel@vger.kernel.org
Cc: "Andi Kleen" <andi@firstfloor.org>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> Any such mechanism will need a syscall, and it's unlikely that
> any syscall will get much cheaper than a kill(SIGSTOP)

But is there a way for the process sending the SIGSTOP to wait until it
has taken effect?  I need a method to *synchronously* stop another
thread.  That's why I thought I probably needed something more
elaborate than SIGSTOP, though I'd like to minimize the number of
system calls required.

Thanks!
Eric Smith

