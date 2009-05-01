Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZEABif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZEABif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZEABi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:38:27 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:33672 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZEABi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B4fcLxwPQ6pOip4Z762CkbtPIBTYik84nIuvIJjUeONkHXn7/2zbSF6Tgf6fA2LIDK
         dhqiMDhXBMVY0zSP5L6ajAaatvSqPcOKPMhegc1/Wr8p9COlkE1xWORPp0TWoRerwMqq
         aaMstnQjvvg2UJy7Ro2ic0LLyakoi7jeXf8K8=
MIME-Version: 1.0
Date: Thu, 30 Apr 2009 21:38:25 -0400
Message-ID: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
Subject: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Parag Warudkar <parag.lkml@gmail.com>
To: johannes@sipsolutions.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Niel bisected the probe timeouts with iwlagn to your commit
47afbaf5af9454a7a1a64591e20cbfcc27ca67a8 .  I too was getting probe
timeouts but with ath9k and tried reverting the above commit which
made the problem disappear.

It is not yet reverted from mainline and compat-wireless - just wanted
to bring it to your notice that it impacts both iwlagn and ath9k.

Thanks
Parag
