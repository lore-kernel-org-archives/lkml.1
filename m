Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYBRWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYBRWCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYBRWCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:02:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYBRWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:02:06 -0500
Message-ID: <47BA002B.7070806@zytor.com>
Date: Mon, 18 Feb 2008 14:01:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl>
In-Reply-To: <47B9FFD5.6040801@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> Yes, but generally not any P5+ system is going to need the PIT delay in 
> the first place meaning it just doesn't matter. There were the VIA 
> issues with the PIC but unless I missed it not with the PIT.
> 

Uhm, I'm not sure I believe that's safe.

The PIT is particularly pissy in this case -- the semantics of the PIT 
are ill-defined if there hasn't been a PIT clock between two adjacent 
accesses, so I fully expect that there are chipsets out there which will 
do very bad things in this case.

	-hpa
