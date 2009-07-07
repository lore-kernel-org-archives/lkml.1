Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZGGJNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZGGJNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZGGJNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:13:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:49288 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753945AbZGGJNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:13:44 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX1/0Tw90/Fb0Y9RFgxNkkNk0Z1712FlsEXXGoAIbhI
	PwxJB/FB5OWThf
Message-ID: <4A5311C7.1020507@warlich.name>
Date: Tue, 07 Jul 2009 11:13:43 +0200
From: Christof Warlich <christof@warlich.name>
Organization: Warlich Consulting
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name>
In-Reply-To: <4A52F39A.1030704@warlich.name>
Content-Type: multipart/mixed;
 boundary="------------070100090902010000080602"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070100090902010000080602
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Christof Warlich schrieb:
> Do you think I can fix the issue and circumvent the BIOS by passing 
> the real geomerty of the drive as kernel boot parameters? This may 
> also have the nice side effect that I could utilize the full capacity 
> of the drive. I'll definitly do some experiments in this direction and 
> let you know immediately if I succeed. Please let me know if this may 
> be a waste of time or if you know an appropriate fix.
I retried with the boot parameter hda=16383,16,63 according to the 
values that I got from fdisk, but without success. Anyway, I would have 
expected that the kernel may have had a way to set the LBA48 geometry 
instead of CHS, but it looks like I'm on the wrong track here...

--------------070100090902010000080602
Content-Type: text/x-vcard; charset=utf-8;
 name="christof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="christof.vcf"

begin:vcard
fn:Christof Warlich
n:Warlich;Christof
org:Warlich Consulting
adr:;;Am Haselhang 7;Hilpoltstein;Bayern;91161;Deutschland
email;internet:christof@warlich.name
tel;work:09174/492914
tel;home:09174/492914
x-mozilla-html:TRUE
url:www.warlich.name
version:2.1
end:vcard


--------------070100090902010000080602--
