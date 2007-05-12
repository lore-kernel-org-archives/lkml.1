Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbXELSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbXELSHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXELSHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:07:21 -0400
Received: from smtp105.plus.mail.re2.yahoo.com ([206.190.53.30]:42045 "HELO
	smtp105.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752314AbXELSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:07:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=z31IxTX4pd9gBtyjfDKS3a7sO+9IEGWW6IpwqQcq6ux7ueqt8+n0hUynOPg9F0uQedWjUwb/6xjjYiVWuVCK+NQFkrcBvLMQOCEPuExyktuRKp+gswLz/wX1SxIVcmf5VO1vIV3DE5hfvuN80yQcBK0pop4MUTyC30sq8fGFnDU=  ;
X-YMail-OSG: ykhxYpIVM1l6LVSj23xjdC_bdklNXQwmoD.MDHSQum.B0AOST0A5MqR38t6qQ6xip5VLyIzaaQ--
Date: Sat, 12 May 2007 20:07:04 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Scheduled removal of SA_xxx interrupt flags
Message-ID: <20070512180703.GA22918@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

   i've been going over the interrupt-handling code and noticed that the SA_xxx
   interrupt flags are scheduled for removal sometime in 9/2007 with a prior
   grace period of 6 months for people to fix external stuff. In order to do so,
   a __deprecated inline function wraps those flags.
   What puzzles me is that the __deprecated-patches are only in -mm and not in
   mainline. Is the -mm-testing audience wide enough to cause userspace to fix
   their apps prior to the SA_xxx removal or am I missing something? I.e,
   shouldn't tglx's patches hit mainline first?

-- 
Regards/Gruﬂ,
    Boris.
