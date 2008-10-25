Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYJYXnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYJYXnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYJYXm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:42:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:32159 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYJYXmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kdysUTT6BpQgcn2oNMu6ikK26asKiVEEi2wqdW7nx6iEal+xvhBeg6akreLVURms9A
         2FAHRQAc4ChPTTMhHM1d3DXC/ekFkWnIYrPpTmoo2RjRYJLyXnr++kWpyu3jRa0z3GOs
         0ZfxCcRVX1Fpyq8vj3Fy86zwxjZr5x3OUuc9s=
Message-ID: <dd18b0c30810251642v51f510e1t8dbf5ba6e082abf2@mail.gmail.com>
Date: Sat, 25 Oct 2008 16:42:54 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: [Bug 10797] Battery is drained after poweroff
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, fabio.comolli@gmail.com,
       astarikovskiy@suse.de, len.brown@intel.com,
       "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <6868482180440484264@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6868482180440484264@unknownmsgid>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 6:23 AM, Renato S. Yamane
<yamane@diamondcut.com.br> wrote:
> Renato S. Yamane wrote:
>> One more information:
>> This bug don't happening in Kernel 2.6.26-8 from Debian Lenny.
>> But still happening in 2.6.27.3 pristine kernel.
>
> Maybe this is the root problem (from Debian changelog):
> *Fix ACPI EC GPE storm detection. (closes:
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494546>
>
> <http://lkml.org/lkml/2008/7/19/19>
>
> Best regards,
> Renato
>
>

Could be, can't remember what happened that day
(maybe too much beer), anyways I have noticed
battery power being lost after power off, but not yet for
2.6.28, I think around 2.6.25-or-26, but when it happened
it was seldom, or in any case once or twice, not enough times
for me to say anything, just figured it was leaving the system
unplugged while in suspend.

-- 
Justin P. Mattock
