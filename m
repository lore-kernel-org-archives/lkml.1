Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXFGVJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXFGVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbXFGVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:09:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2513 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXFGVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:09:49 -0400
Date: Thu, 7 Jun 2007 23:09:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miloslav Trmac <mitr@redhat.com>
cc: casey@schaufler-ca.com, Steve Grubb <sgrubb@redhat.com>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
In-Reply-To: <46685C67.7000108@redhat.com>
Message-ID: <Pine.LNX.4.64.0706072305380.1370@fbirervta.pbzchgretzou.qr>
References: <442798.53194.qm@web36614.mail.mud.yahoo.com> <46685C67.7000108@redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1823640002-1181250588=:1370"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1823640002-1181250588=:1370
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jun 7 2007 21:28, Miloslav Trmac wrote:
>Casey Schaufler napsal(a):
>>> If we do not get commands typed at a prompt, we have to audit by execve. 
>> I would suggest that you'll have to do that as well so that you can tell
>> the difference between typed actions like these:
>> 
>> # cat > /dev/null
>> badprogram --badthing --everyone
>> ^D
>> #
>> 
>> # badprogram --badthing --everyone
>> 
>> where the same typed line is a Bad Thing in one case and completely
>> irrelevent in the other.
>The proposed patch audits each process separately, and includes a part
>of the command name in the audit event, so it is easy to distinguish
>between data entered into (cat > /dev/null) and the shell.
>
>The command name can be faked, but the actions necessary to fake the
>command name would be audited.

Someone please enlighten me why a regular keylogger² that captures
both input and output could not do the same. (Auditing what one has done.)

² http://ttyrpld.sf.net (there are others too)



	Jan
-- 
---699020219-1823640002-1181250588=:1370--
