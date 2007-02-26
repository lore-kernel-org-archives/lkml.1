Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXBZIz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXBZIz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 03:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXBZIz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 03:55:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:40334 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXBZIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 03:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BgdKa68kK3wgfIm1kwAZ4FUd1xcwkJAXSZyNZqJcSNltvwU3nEHO94qzWN65Bo/iyU/I7cP6vf5bgUTU4eqkzUJuU/tHEFhOqBt3YuzmD7VrvPM2FF8vuoX7/+40toGPlbn4MfogqGkw1jV7E36RPeuirzFXnIUVL3HDcZE76Nc=
Message-ID: <8d158e1f0702260055m5d3cf93cqce58e366d677c090@mail.gmail.com>
Date: Mon, 26 Feb 2007 09:55:54 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PROBMEL] MD doesn't like /dev/disk/by-id
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I posted this a while ago aswell :)

MD can't start anymore when /etc/mdadm.conf uses /dev/disk/by-id/* ,
it bluntly tells you there are no suiteable drives.

Since libata tends to mangle my drive order by every reboot since I
use 3 controllers and the drivers dont generate uevents always in the
same sequence the only thing left to use are UUIDs.

Now, this isnt a problem but is this the *only* way the mdadm devices
will startable now and is this the only way the MD module will
support?

And if yes, maybe this should be communicated somewhere, cause
something tells me I am not the only one who had this problem or will
have :)


Patrick
