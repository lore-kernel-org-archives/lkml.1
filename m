Return-Path: <linux-kernel-owner+w=401wt.eu-S1946320AbXBQAEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946320AbXBQAEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946329AbXBQAEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:04:43 -0500
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:23371 "HELO
	smtp001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946320AbXBQAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:04:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mK1rbIK27PIbXpjbPPq4iajPVAiSlU/mj/GpWKtgr6fh2zsbUiKnjRTlN2W14YMlKK39T8FEcqqFANmSXK6gMYK+L/2Pc0OxEQRP7R1xZ9TR3PCmiZ/SJ2tbT7pgdjCRoyZm8S+ln2b3u11DIiqfR+7cDpCu5stvkCEJGfZ/HlQ=  ;
X-YMail-OSG: sgqXiiAVM1m3WrleECdJf5AAO8zi2I_QsQDsMT5ndUxfd0Vge3J81bjCC2TSvpVuMm5LdUuJwu.ip5Ui3oKRP9BYDzvLSde8695Op.CRkWoZeGc_4_Qp6Kp3_eS3A21AWXbWH433lr8.
From: Blaisorblade <blaisorblade@yahoo.it>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Date: Sat, 17 Feb 2007 01:04:35 +0100
User-Agent: KMail/1.9.5
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <200702152005.56594.blaisorblade@yahoo.it> <20070216190204.GB7481@ccure.user-mode-linux.org>
In-Reply-To: <20070216190204.GB7481@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702170104.36122.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 20:02, Jeff Dike wrote:
> On Thu, Feb 15, 2007 at 08:05:56PM +0100, Blaisorblade wrote:
> > Jeff, I verified my patch is _almost_ enough for 2.6.18 for fully booting
> > a 32bit UML; on 2.6.18 I had to also add PTRACE_GET/SET_THREAD_AREA (this
> > fix was merged in 2.6.19) to avoid tons of TLS errors.
>
> I'm not seeing that.  With the current set of patches, I have 32-bit UMLs
> happily booting on x86_64.
Which kernel? I've not yet tested 2.6.20. I'll try debugging this 
subsequently.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
