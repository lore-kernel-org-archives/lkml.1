Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbYI3S1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbYI3S1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYI3S1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:27:35 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:49886 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYI3S1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:27:34 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: Linux 2.6.27-rc8
Date: Tue, 30 Sep 2008 15:27:39 -0300
User-Agent: KMail/1.9.10
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <48E1DC40.2020508@tremplin-utc.net> <20080930132831.1cc4d56c@doriath.conectiva>
In-Reply-To: <20080930132831.1cc4d56c@doriath.conectiva>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301527.40636.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008 13:28:31 Luiz Fernando N. Capitulino wrote:
> Em Tue, 30 Sep 2008 09:58:56 +0200
>
> Eric Piel <eric.piel@tremplin-utc.net> escreveu:
> | Jiri Kosina schreef:
> | > On Mon, 29 Sep 2008, Linus Torvalds wrote:
> | >>> If it is X related then its both a kernel + X server issue, the
> | >>> e1000e driver opens the barn door, the X server drives the horses
> | >>> through it.
> | >>
> | >> Are you sure? There was a mandriva report abou NVM corruption on an
> | >> e100 too (that one apparently just caused PXE failure, the networking
> | >> worked fine).
> | >
> | > That is very probably completely separate issue, and shoudl have been
> | > fixed already by 78566fecb.
> |
> | Likely not, you are mentioning a patch for e1000, while the Mandriva bug
> | report is about e100:
> | https://qa.mandriva.com/show_bug.cgi?id=44192
>
>  Yes, also the reporter has said that he has got the problem with -rc7 and
> this fix is available since -rc6.
>
>  Jiri, doesn't e100 need that fix as well?
>
>  Anyway, it is not clear for us whether this is a kernel problem. We
> could not reproduce it here and the reporter is now checking his network.

He finished checks and discovered the e100 issue was in reality a hardware 
problem in the switch being used that started to have problems now, 
coincidently with this e1000e issue getting more attention, after swapping 
the switch the problem stopped, so just a false alarm. I closed 
https://qa.mandriva.com/show_bug.cgi?id=44192 that was the original report.

--
[]'s
Herton
