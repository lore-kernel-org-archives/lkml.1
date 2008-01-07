Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYAGQ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYAGQ13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYAGQ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:27:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41246 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYAGQ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:27:21 -0500
Date: Mon, 7 Jan 2008 17:27:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: smpboot_64 section mismatch warning
Message-ID: <20080107162718.GA16072@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <20080107165344.28e9f1ed@Varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080107165344.28e9f1ed@Varda>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 04:53:44PM +0100, Alejandro Riveira Fernández wrote:
> 
>    MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x10508): Section mismatch: reference to .init.text:fork_idle (between 'do_fork_idle' and 'lapic_timer_broadcast')

Caused by following commit:
commit 65f27f38446e1976cc98fd3004b110fedcddd189
Author: David Howells <dhowells@redhat.com>
Date:   Wed Nov 22 14:55:48 2006 +0000

    WorkStruct: Pass the work_struct pointer instead of context data


David - will you look into this?

	Sam
