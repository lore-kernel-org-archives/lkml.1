Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXKTW63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXKTW63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXKTW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:58:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:46177 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXKTW6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q/gVGOiGjE9N/OMrDwPcFRhDJSUx8UwKuHBBbmlZ2lkpdsGQhBQG9HU6hgL+mem3ZPejeTNXF1vuGqNvKj44Jxt0q8/o2lti4V7i32hp6zlARgECHzs5vW9mBj6TIBI6oKZt7oP1YUKQ6oxURfLa6SA9Uf8aZrD31PFnzSZIXK8=
Message-ID: <3d8471ca0711201458v16b05245kc408aa8021005050@mail.gmail.com>
Date: Tue, 20 Nov 2007 23:58:14 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] proc: Fix the threaded /proc/self.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <m1k5ocr14n.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl>
	 <4743026B.2020907@openvz.org>
	 <m11wakshyz.fsf@ebiederm.dsl.xmission.com>
	 <20071120215914.GE24156@elte.hu>
	 <m1k5ocr14n.fsf_-_@ebiederm.dsl.xmission.com>
X-Google-Sender-Auth: cf775fdcd2640285
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

This fills a need I had to get the current TID in a Java program,
so I'm very interested in this change. OTOH, how will someone
not reading LKML discover that the current TID is now in
/proc/self and that it was not always the case?

I would put my 2 cents in /proc/self/task/self, this way TGID are
always in /proc and TID in /proc/TGID/task.

-- 
Guillaume
