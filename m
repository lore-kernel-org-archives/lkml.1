Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbYKRII5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbYKRII5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYKRIIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:08:47 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:3093 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYKRIIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:08:47 -0500
Message-Id: <49228648.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Nov 2008 08:09:28 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117175232.GA13766@mailshack.com>
In-Reply-To: <20081117175232.GA13766@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alexander van Heukelum <heukelum@mailshack.com> 17.11.08 18:52 >>>
>The macro "interrupt" in entry_64.S generates a lot of code and it
>is used more and more often. This patch moves most of its contents
>into an external function. This saves anywhere between 500 and 2500
>bytes of text depending on the configuration.

Without numbers, I'd doubt that the code size reduction outweighs the
overhead of the extra call. Did you do any measurements?

>Dwarf2-annotations are most probably wrong or missing at all.

Indeed - do you have intentions to address this?

Jan

