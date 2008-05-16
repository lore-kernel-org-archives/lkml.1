Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYEPOeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYEPOeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYEPOe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:34:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11710 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYEPOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RTm9dq6BJh+ZmktMMh86sDyzhBWLh5YbBOgHSM6u2Id8AlEPiH0mQ+D5S19BFyCYQ7c2dGQL3P12vD3L3KaE1SO3nrfoQDEhmbI5UO7jIYNoMjnEMBgWWtaMrkm+SbptrVgt+n627HvVoBTl1ST1wKSzZnHI9d3bAvDfU+WsdYo=
Message-ID: <6101e8c40805160734t12d5fbe8ud63fe2ab1681cd13@mail.gmail.com>
Date: Fri, 16 May 2008 16:34:23 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Bad value with w83627thf
Cc: "LM Sensors" <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080516162634.26207258@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40805160559i4eb94ba7y7cbfea9c3f528821@mail.gmail.com>
	 <20080516152712.629606bf@hyperion.delvare>
	 <6101e8c40805160645x5982d5ads61a422f5600f7507@mail.gmail.com>
	 <20080516162634.26207258@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean!

[snip]

> When you reboot your machine, the W83627THF device is not reset, so the
> configuration steps done by the w83627hf driver of kernel 2.6.25+
> remain. However, if you stop the machine then start it again, the
> configuration is lost.

yean I thinked this, but dont know, what is this base (the git commit explained)
>
> [1]
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef878b11ba245d14b7db7816217a825d6a894182
>
> --
> Jean Delvare
>

thanks the help, and then i backported this commit to 2.6.22.y and
changed the limit values in sensors.conf

-- 
Thanks,
Oliver
