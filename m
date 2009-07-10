Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbZGJUnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbZGJUnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbZGJUnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:43:17 -0400
Received: from smtp146.mail.mud.yahoo.com ([209.191.106.57]:28801 "HELO
	smtp146.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756070AbZGJUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:43:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 16:43:16 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.ar;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=y97A7NzpKj+xnWfHCx0GgD417cfyHB4aNF7tcqoI6sSeENpkurdsbqYLMLdqlHO66unP+1NoW6ahLOypQGmgfuJ6ggVFXH7zZiCkD+2a/BRRAQgA3p8EQHB2o6j4DBrn043ATiW7wJYCMrn6mFhWiFs95MZUP26YvDh9/IZ087Q=  ;
X-Yahoo-SMTP: MJlmAJmswBD1ci8cgZcdLoLtCohJxg8-
X-YMail-OSG: ExrprCsVM1kqdQv_A1YYz8ZhwjXj7sYCebZuGwJch6sn9AJHfdSwMDsHhx8EsdokKXOHoFb3zuw3Dylbav0_SHRx7kZX9evGuzujOc5D_Dhobt3F4Rx5vPxT8n183zWtIcCAWCWrEq_2c_I_mZFu9gXYM1he48z_TJkSMMpGxLJTCkvwVC1Ezs0iAZhky37kjUDnI0VlBxOFG.4HQzprJnIuWEyNu7nQH6UptyNFYKuKX2_zmsYlNRbC1AyuGXEzSkFXDJFLkCGQ6aayiX7LP.pgb5JPcSQXZjAZJ8YhcX3SBmP8tv_jq8vP0eUUjNaPAsbt3yfcPAMcbATu1OsSPioonyx3u0Fg7Wg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A57A62C.2030302@yahoo.com.ar>
Date: Fri, 10 Jul 2009 17:35:56 -0300
From: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: No more vcs1 and vcsa1 in 2.6.30.N
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Since upgrade my system to 2.6.30[.1]. I don't have anymore
/sys/devices/virtual/vc/vcs1 and /sys/devices/virtual/vc/vcs1 in
consequence not have anymore the corresponding char devs in /dev.

The problem is with this commit: {vcs: hook sysfs devices into object
lifetime instead of "binding"} [#1]
Reverting it solves the issue.

[#1]
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=commitdiff;h=4995f8ef9d3aac72745e12419d7fbaa8d01b1d81

Cheers,


Please CC to me, not subscribed to LKML. Thanks.

-- 
Gerardo Exequiel Pozzi ( djgera )
http://www.djgera.com.ar
KeyID: 0x1B8C330D
Key fingerprint = 0CAA D5D4 CD85 4434 A219  76ED 39AB 221B 1B8C 330D

