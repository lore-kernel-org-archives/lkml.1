Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYGRL2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYGRL2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYGRL2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:28:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:58966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbYGRL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rVeF51N3GlZKzxMM8eNrH/+skzPooC698P/IA8pRear9gdob3Mre/8frmQJQTwdV2p
         QWv3Lld6RJd3HXlMlARHVlmAKGBPnCHaGLO73i5GKL2LcmlzBPzpYOJDQsQgqYoNf9BH
         VPCNzybMzvO83x+kp+WZ1MSsnH+PFQmGDiq2A=
Message-ID: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
Date: Fri, 18 Jul 2008 14:28:44 +0300
From: "Brian Marete" <bgmarete@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L: Link tuner before saa7134
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
>
> #1 users can't set thetunertype anymore,
>    but the few cases oftunerdetection from eeprom we have should
>    work again for that price.

Hello,

Any patch yet for above issue? It seems to have made it into 2.6.26.

I use saa7134 with everything, including the tuner modules, compiled
as a module. My card is detected as a flyvideo2000. The default tuner
for that card (#37) allows me to tune into TV but not to FM Radio. I
can access both functions (TV and FM Radio) if I override with
tuner=69, which is what I usually do. That override does not work on
2.6.26.

Any suggestions?

Thanks,

-- 
B. Gitonga Marete
Tel: +254-722-151-590
