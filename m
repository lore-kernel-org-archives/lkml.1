Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbXEWXaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbXEWXaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbXEWXaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:30:00 -0400
Received: from web90311.mail.mud.yahoo.com ([216.252.100.148]:23089 "HELO
	web90311.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756748AbXEWXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:30:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UjpJxk8Q00TWe5rD/kZrWrIJDBr7rzprMR2ljjLjCE0YMrtDbtuXTyFw+7mwyf5twUrM1Mco2akknncw1Huiscg9djsPDPO4HfhGL88bu0hyClzuCmxMsLI7q1UAd1jqNr5iMea/vZyQ3dIl2oNcmslTPOOPUddmH4HxfWb4ssk=;
X-YMail-OSG: NAybkzwVM1lsklVvMWca.D3Ix5br__fnywKNCKxbrOq8NrBmOEtpGtvOtBbG3oH18xGLUe3RtqdFGeJlbXE2B2Hw5Dhsr9WSyh9d
Date: Wed, 23 May 2007 16:29:59 -0700 (PDT)
From: Y Khan <ykhanportland@yahoo.com>
Subject: Re: class_device_create() and the mode of the device file in /dev.
To: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <3ae72650705222046o352ca76epbd5c36dea7706e70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <358502.73138.qm@web90311.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> No, the kernel is not involved in specifying /dev
> permissions. You
> have to add a udev rule to assign a mode that isn't
> the default.
> 

Hmm...When I can create the device file automatically
then I should also be able to specify the mode. udev
can override this value from kernel if it has another
value from the user. But not having this capability in
the kernel kind of distributes the work (part 1 done
in kernel while part 2 done in user space), which is
not very friendly. Now I will have to distribute a
udev conf file along with my driver.

I can make changes to udev/kernel for this if people
think that this is also desired by others.

-Y



       
____________________________________________________________________________________You snooze, you lose. Get messages ASAP with AutoCheck
in the all-new Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_html.html
