Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZF1NhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZF1NhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZF1NhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:37:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:33468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752188AbZF1NhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:37:00 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX19E4LFZdUhETP/dVS85zNEUh0+Sw+cBnc/+ycPoRX
	0OCML020wyJR8Y
Message-ID: <4A4771FD.1020207@warlich.name>
Date: Sun, 28 Jun 2009 15:37:01 +0200
From: Christof Warlich <christof@warlich.name>
Organization: Warlich Consulting
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "EXT3-fs error" after resume from s2ram
Content-Type: multipart/mixed;
 boundary="------------000309040705040907010700"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309040705040907010700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

when I call "s2ram -f -p" from  vt1 on my HP TC1100, the system suspends 
fine, and
when resuming,  it even comes back showing the command prompt, but only 
after
an avalanche of error messages like:

[ 1598.962543] EXT3-fs error (device sda3): ext3_find_entry:
reading directory #1025639 offset 0

After that, any access to the harddisk (e.g. calling commands like ls) 
results
in similar EXT3-fs error messages.

On the other hand, suspend to ram works fine when I install on a USB 
stick, so the
problem seems to be related to the harddisk subsystem. Furthermore,  the 
hardware
itself seems to be fine, as s2ram works with Windows XP.

I tested with a vanilla 2.6.30 kernel.

Please let me know if any further debugging information is required.

Thanks for any help,

Christof

--------------000309040705040907010700
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


--------------000309040705040907010700--
