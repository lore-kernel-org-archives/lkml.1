Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZLWN27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZLWN27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZLWN25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:28:57 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46416 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbZLWN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=nsGrLBOF5045kyiPsTtm86w8lnE32k5O9Ovw8wjPG6C7G5OYOJtKDKpEjrc8rSKZxH
         0BQTAc8OEIcZ0jycoEFNl/txEQTfEH8lf636IA/2T+T94Vmo9Jh12nj2oVrdRfJf0aGr
         +AS2hW3YlZf+QLem4Pg4zWaW0bsY58n+4j0lo=
Date: Wed, 23 Dec 2009 15:28:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kalle.valo@nokia.com, johannes@sipsolutions.net
Subject: using X: in MAINTAINERS is broken
Message-ID: <20091223132833.GF17923@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, kalle.valo@nokia.com,
	johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following command doesn't generate any output.
`./scripts/get_maintainer.pl --no-git -f drivers/net/wireless/wl12xx/wl1271_acx.c`

If you comment out the X: line from the WL1251 it does generate output.
WL1251 WIRELESS DRIVER
M:      Kalle Valo <kalle.valo@nokia.com>
L:      linux-wireless@vger.kernel.org
W:      http://wireless.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
S:      Maintained
F:      drivers/net/wireless/wl12xx/*
X:      drivers/net/wireless/wl12xx/wl1271*

WL1271 WIRELESS DRIVER
M:      Luciano Coelho <luciano.coelho@nokia.com>
L:      linux-wireless@vger.kernel.org
W:      http://wireless.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
S:      Maintained
F:      drivers/net/wireless/wl12xx/wl1271*

regards,
dan carpenter

