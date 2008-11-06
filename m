Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYKFPbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYKFPbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKFPba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:31:30 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47959 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYKFPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:31:29 -0500
X-Sasl-enc: OCkoHfKzWD8j/dzNqW7DkpeMl6rsHV2R6Spw3sT20NG9 1225985488
Date: Thu, 6 Nov 2008 13:31:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106153124.GE23278@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61> <20081106141121.GB23278@khazad-dum.debian.net> <20081106152255.GA23717@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106152255.GA23717@x61>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008, Tino Keitel wrote:
> Then it seems I misunderstood the whole fan state resume stuff. I
> thought that it restores the value that was set before suspend, unless
> it was set to some emergency value meanwhile. I think I should not look

No, it basically cannot slow down the fan, no matter what.  And yes, it
needs comments.  I will abuse the opportunity of this regression fix to
insert them.

> > Maybe something in the hwmon class is also trying to keep values across
> > sleep/suspend?
> 
> This happened only with my first (broken) patch, so no need to bother
> about this.

Ok.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
