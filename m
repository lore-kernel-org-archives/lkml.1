Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXIIJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXIIJLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbXIIJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:10:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:44669 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbXIIJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hn10mQl192dF5eiMGlhPZQjLizJVYVGOve5tq6aNMCm/lNHGiuLQHZkRMXut5+ZzrrEK44AFfftWZqIENCmxN/9oQZspQ+RSMDE152meGf8hbkP1FBzyj4n7aHCRa3EUCBq/WWBqtyhM8qzKFT2zhqzSAKQMRgVhczIni6EuxZY=
Message-ID: <46E3B89B.2080600@gmail.com>
Date: Sun, 09 Sep 2007 11:10:51 +0200
From: Maciek Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Suspend and hibernation status report
References: <200707271057.05438.rjw@sisk.pl> <200709041932.21281.lenb@kernel.org> <200709082340.37018.rjw@sisk.pl>
In-Reply-To: <200709082340.37018.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
> 
> Well, I am.
> 
> On HPC nx6325 the status of AC adapter after the restore is not reported
> correctly if hibernation is done without the ACPI hooks (eg. if you hibernate
> with the AC connected and then disconnect it and resume, it will still be
> reported as connected until you plug/unplug it).
> 
> There are more machines that behave similarly, AFAICT.

I notice similar issue on nx6310 when e.g. hibernation->remove
battery->resume doesn't refresh power status. But when I add:

echo platform > /sys/power/disk

Problem goes away


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
