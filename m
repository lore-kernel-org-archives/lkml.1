Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZDLFEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZDLFEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 01:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZDLFEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 01:04:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35246 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbZDLFEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 01:04:08 -0400
X-Sasl-enc: R0r8vRk6xjm5gJN9UuaQoqqPusKRXl3jK7cVEvZqOxyr 1239512647
Date: Sun, 12 Apr 2009 02:04:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
	brightness with hotkeys
Message-ID: <20090412050405.GB8211@khazad-dum.debian.net>
References: <49E10684.5090101@gmail.com> <20090411150555.8b13ed18.akpm@linux-foundation.org> <49E11FD0.9040403@gmail.com> <49E12378.8070200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E12378.8070200@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009, Niel Lambrechts wrote:
> Okay, please bear with me (I'm a git novice) but when I did
> 
> 'git revert 0e501834f8c2ba7de2a56e332d346dcf4ac0b593'
> 
> and recompiled I was still unable to control the brightness with the
> hotkeys...

Which is not surprising.  None of those codepaths are active for your
thinkpad, at least not by default.

Try bissecting keyed to changes to the ACPI video driver, or to the whole
acpi directory (but do try Linus' latest git kernel, first. One never
knows...)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
