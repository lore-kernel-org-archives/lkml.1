Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbXJSPUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbXJSPUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXJSPUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:20:35 -0400
Received: from main.gmane.org ([80.91.229.2]:47115 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXJSPUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:20:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: OOM notifications
Date: Fri, 19 Oct 2007 17:18:06 +0200
Message-ID: <87lk9zgmkx.fsf@willow.rfc1149.net>
References: <20071018202504.GA2854@dmt> <4717C43D.6030204@keyaccess.nl> <20071018165238.0537eaa6@bree.surriel.com> <4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com> <4717D7B6.40102@keyaccess.nl> <4717D9BF.4010508@redhat.com> <20071019101743.GA24354@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: zaphod.rfc1149.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:tc8R6zui9SMRrbmuGP48Ygs/2hs=
X-Leafnode-NNTP-Posting-Host: 2001:6f8:37a:2::2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Pavel" == Pavel Machek <pavel@ucw.cz> writes:

Pavel> That works okay on a PC, but try cellphone one day.

Pavel> You want management app to close the least used
Pavel> application. You do not want _kernel_ to select "who to send
Pavel> SIGTERM to".

That's why I would prefer that *all* processes receive the
SIGDANGER/whatever (and of course ignore it by default). Only the
management app would handle it in the case you describe and would
select one or more applications to unload to free some memory.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

