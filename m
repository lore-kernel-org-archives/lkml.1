Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYBRWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYBRWbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYBRWaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:30:52 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:40536 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYBRWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:30:52 -0500
Message-ID: <47BA077B.50401@keyaccess.nl>
Date: Mon, 18 Feb 2008 23:32:27 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl>
In-Reply-To: <47BA0188.6000808@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-08 23:07, Rene Herman wrote:

> On 18-02-08 23:01, H. Peter Anvin wrote:
> 
>> Rene Herman wrote:
>>>
>>> Yes, but generally not any P5+ system is going to need the PIT delay 
>>> in the first place meaning it just doesn't matter. There were the VIA 
>>> issues with the PIC but unless I missed it not with the PIT.
>>>
>>
>> Uhm, I'm not sure I believe that's safe.
>>
>> The PIT is particularly pissy in this case -- the semantics of the PIT 
>> are ill-defined if there hasn't been a PIT clock between two adjacent 
>> accesses, so I fully expect that there are chipsets out there which 
>> will do very bad things in this case.
> 
> Okay. Now that they're isolated, do you have a suggestion for 
> {in,out}b_pit? You say a PIT clock, so do you think we can bounce of the 
> PIT iself in this case after all?

Am I correct that channel 1 is never used? A simple read from 0x41?

Rene.
