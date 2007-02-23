Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbXBWSHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbXBWSHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932589AbXBWSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:07:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:53870 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbXBWSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=XNUejvNb0zF5EnIIM9cX5AQQqxhFkdpqeO1KUZs98x/CKawrIcv7+tPtFcj4XGD7u/hsDjokuXeQrbi+cMNDuzCQLlGcqybewfJoKhCdpUXdK36c+JoSBA1O2yBG9bQKsGBLWV9ioNcrUGJir4HLEG6zmFdL/GhZbyRyDlLL+v0=
Date: Fri, 23 Feb 2007 20:07:39 +0200
To: linux-kernel@vger.kernel.org
Subject: Video GL rendering worked only between 2.6.20 and 2.6.21-rc1
Message-ID: <20070223180643.GA6828@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Aiglx/Beryl effects (transparency and other stuff) on windows that display 
video worked magically for the first time in a pull point between 2.6.20 and 
2.6.21-rc1. Unfortunately It doesn't work again now in 2.6.21-rc1 and even in 
2.6.20-mm{1,2}.

I'm not able to find the good commit again :(. Could someone please tell
me the files that is most probably responsible for video GL rendering 
so I can track their changes and find the good commit.

The machine is a Centrino laptop with an i810 card. So I guess those are 
the responsible files:
    
    drivers/char/drm/i810_*.c
    drivers/video/i810/*

Any more probably responsible files? 

Thanks,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

