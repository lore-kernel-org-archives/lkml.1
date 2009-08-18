Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZHRXq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZHRXq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZHRXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:46:57 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:43207 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZHRXq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:46:57 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 19:46:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WTcJQLN0lhLlcJoPUtCtjmxZwV/o5dVw/9f/kIGjw79qkqw1EaU90+vSAuzoB9Tnl4
         7PEaZZcBkmikrD7WetbrbSGTMoKw1vVKGlSrYjdJLe+UuduFA1dcqO7RDIPXsIRAKHic
         XxnJNzroRE8SfuiBMWgLlQPbidMKVprXd63bQ=
MIME-Version: 1.0
In-Reply-To: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 18 Aug 2009 16:41:20 -0700
Message-ID: <43e72e890908181641s2455e7f1me9b4d3bc277f197e@mail.gmail.com>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) now ready for 
	testing!
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/18 Gábor Stefanik <netrolller.3d@gmail.com>:
> Hello World!
>
> Great news for Broadcom BCM4310/4312/4315 (PCI 14e4:4315) users:
> LP-PHY support is now at the point where it can be tested for functionality!

Hey great stuff :)

> There are still problems with channel switching (a few patches ago,
> only 802.11b/g channels 7 and 8 were working - no tests have been
> performed since then) & TX is untested, but Larry has reported that he
> can get scan results from channels 7 and 8. He doesn't have any AP on
> these channels, so can't test if association works, but it should be
> working too. It's also possible that recent patches have fixed the
> channel switching bug, as the codepaths for channel switching have
> been touched extensively, probably fixing a major miscalculation issue
> ("Qdiv roundup" was completely wrong).
>
> So, go ahead, give it a try, and let's rock!
>
> Note that the code in wireless-testing is enough to start testing,
> however it's recommended that you apply the following 2 pending fixes:
> http://marc.info/?l=linux-wireless&m=125061590101156&w=2 and
> http://marc.info/?l=linux-wireless&m=125062611720517&w=2
>
> Tomorrow's compat-wireless tarball, together with the above patches,
> should also be good for testing. Not sure about today's tarball.

Except CONFIG_B43_PHY_LP was not enabled on compat-wireless. But now
it is. I kicked the cronjob and enabled CONFIG_B43_PHY_LP on
config.mk, please report any issues.

http://wireless.kernel.org/en/users/Download/

BTW I think it would be nice for those users looking only for b43 for
us to update scripts/driver-select to have b43 as just one driver
option. Should be easy to add but I don't have time right now. Patch
is greatly welcomed though.

  Luis
