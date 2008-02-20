Return-Path: <linux-kernel-owner+w=401wt.eu-S1764544AbYBTRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764544AbYBTRHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYBTRHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:07:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYBTRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:06:59 -0500
Message-ID: <47BC5DF4.9020300@zytor.com>
Date: Wed, 20 Feb 2008 09:05:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com> <47B9FFD5.6040801@keyaccess.nl> <47BA002B.7070806@zytor.com> <47BA0188.6000808@keyaccess.nl> <47BA077B.50401@keyaccess.nl> <47BA0A3D.1060708@zytor.com> <47BC17BE.9010800@keyaccess.nl>
In-Reply-To: <47BC17BE.9010800@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> _Something_ like this would seem to be the only remaining option. It 
> seems fairly unuseful to #ifdef around that switch statement for kernels 
> without support for the earlier families, but if you insist...
> 

"Only remaining option" other than the one we've had all along.  Even on 
the one idiotic set of systems which break, it only breaks post-ACPI 
intialization, IIRC.

	-hpa
