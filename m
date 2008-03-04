Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYCDLP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYCDLP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYCDLPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:15:20 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55275 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbYCDLPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:15:19 -0500
Date: Tue, 4 Mar 2008 12:14:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Diego Woitasen <diego@woitasen.com.ar>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: High resolution timer/dynticks bug
In-Reply-To: <20080304110900.GA23227@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0803041213260.18589@twin.jikos.cz>
References: <20080303010753.GB3512@motherbox.xtech.com.ar>
 <20080304110900.GA23227@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Pavel Machek wrote:

> Just turn off NMI watchdog? Pulling the power cable causes the SMM trap, 
> which takes _long_ to execute, potentially tickling NMI watchdog?

By _long_ you mean leaving the system for 5 seconds with irqs disabled? 

-- 
Jiri Kosina
SUSE Labs

