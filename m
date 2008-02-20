Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbYBTRIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbYBTRIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYBTRIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:08:16 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:59527 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYBTRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:08:15 -0500
Message-ID: <47BC5EE3.5090101@keyaccess.nl>
Date: Wed, 20 Feb 2008 18:09:55 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl> <47BA077B.50401@keyaccess.nl> <47BA0A3D.1060708@zytor.com> <47BC17BE.9010800@keyaccess.nl> <47BC5DF4.9020300@zytor.com>
In-Reply-To: <47BC5DF4.9020300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-02-08 18:05, H. Peter Anvin wrote:

> Rene Herman wrote:
>>
>> _Something_ like this would seem to be the only remaining option. It 
>> seems fairly unuseful to #ifdef around that switch statement for 
>> kernels without support for the earlier families, but if you insist...
>>
> 
> "Only remaining option" other than the one we've had all along.  Even on 
> the one idiotic set of systems which break, it only breaks post-ACPI 
> intialization, IIRC.

Linus vetoed the DMI switch.

Rene.
