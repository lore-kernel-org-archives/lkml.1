Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYH3UZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYH3UZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3UZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:25:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57821 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYH3UZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:25:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: [Regression] sshd hangs on close
Date: Sat, 30 Aug 2008 22:28:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <g9b39n$4et$1@ger.gmane.org>
In-Reply-To: <g9b39n$4et$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302228.58255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Saturday, 30 of August 2008, Matthias Urlichs wrote:
> "top" sees multiple instances of:
> 
>  6008 root      20 3184 D    0   0:00.06 flush_cpu sshd: root@pts/13            
> 
> This is 2.6.27rc5, preemption and tickless turned on, on a 4-CPU machine.
> (OK, two hyperthreaded ones :-P) strace() shows that this happens on the
> last close of its /dev/ptmx file descriptor, which hangs.
> 
> I'll do a bisect early next week unless somebody else identifies a likely
> suspect.
> 


