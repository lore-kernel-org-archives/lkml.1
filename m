Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXLHWJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXLHWJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXLHWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:09:09 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:47944 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752192AbXLHWJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:09:07 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Sun, 9 Dec 2007 00:10:10 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de>
In-Reply-To: <20071208220345.GE20441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712090010.10362.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 09 December 2007 00:03:45 tarihinde Adrian Bunk şunları yazmıştı:
> On Thu, Dec 06, 2007 at 02:32:05PM -0500, Bill Davidsen wrote:
> >...
> > Sounds like a local DoS attack point to me...
>
> As long as /dev/random is readable for all users there's no reason to
> use /dev/urandom for a local DoS...

Draining entropy in /dev/urandom means that insecure and possibly not random 
data will be used and well thats a security bug if not a DoS bug.

And yes this is by design, sigh.

-- 
Never learn by your mistakes, if you do you may never dare to try again.
