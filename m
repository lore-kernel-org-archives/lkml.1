Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYHZQCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYHZQCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYHZQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:02:35 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:43508 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbYHZQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:02:35 -0400
Date: Tue, 26 Aug 2008 13:02:16 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826130216.4d723b0a@doriath.conectiva>
In-Reply-To: <20080826141851.GA5300@tux1.brauer.lan>
References: <48ADDF4F.2020401@zytor.com>
	<48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<20080822163520.GA9860@Krystal>
	<20080822142054.403cbdef@doriath.conectiva>
	<20080822175741.6bc83dc8@doriath.conectiva>
	<48AF2ABD.9070100@zytor.com>
	<20080826141851.GA5300@tux1.brauer.lan>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 26 Aug 2008 16:18:51 +0200
Gerhard Brauer <gerhard.brauer@web.de> escreveu:

| On Fri, Aug 22, 2008 at 02:08:13PM -0700, H. Peter Anvin wrote:
| > Luiz Fernando N. Capitulino wrote:
| >>
| >>  I have asked Mandriva and Ubuntu users to test this and all of
| >> them so far are saying that noreplace-paravirt works.
| >>
| >>  It makes the system slower, but it works.
| >>
| >
| > Yes, the big issue is exactly what VirtualBox screws up in this matter,  
| > how to detect it, and how to work around it.
| >
| > It's pretty clear it's a VirtualBox f*ckup at this point, but the failure 
| > mechanism isn't at all obvious and so far the workaround is elusive.
| >
| > I'm strongly suspect this is a VirtualBox tcache management failure, but  
| > that doesn't help the situation without knowing how it happens.
| 
| On Archlinux we have the same problem. We have a bugreport here:
| http://bugs.archlinux.org/task/11141
| 
| Myself test it with a LiveCD/Install-ISO which has 2.6.26 as install
| kernel. We have the guest oops on virtualbox-ose, virtualbox-sun and both on
| i686 or x86_64 hosts.
| 
| Some things i noticed:
| - The system boots always when i either enable VT-x in guest settings or
|   disable acpi and run the guest with acpi=off.

 Yes, lots of ubuntu users have reported the same but another "lots"
of them have reported that the trick didn't work.

 Thanks for joining!

-- 
Luiz Fernando N. Capitulino
