Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYEDBGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYEDBGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 21:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYEDBGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 21:06:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:11187 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYEDBGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 21:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XHsFZJ/Zy4dwHzO0HxrS/mLcP2e3E2u+4Cvw5SFvD0jWh5ZttlmPC5lxflK66l1wcdP/IguIkwNm34aDNGdqYKb9tQzF1WporokHQDWtolcrc01BBxAlnJpLT/58vyMZK5g2/e7Bdw7LViOImb/3MpkLenBAQNvZCkRE/g50k1s=
Message-ID: <75b66ecd0805031806n322b6633j35498fa3b88f9da9@mail.gmail.com>
Date: Sat, 3 May 2008 21:06:14 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting With 2.6.24.5 Kernel
Cc: "Phil Oester" <kernel@linuxace.com>, "Ryan Roth" <ryanroth@sbcglobal.net>,
       Ryan.Roth@ch2m.com, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080502061018.5557d067.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501130444.cc5c63e8.akpm@linux-foundation.org>
	 <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	 <481A5276.4040607@sbcglobal.net>
	 <20080501170239.9b740877.akpm@linux-foundation.org>
	 <481A5A94.2080400@sbcglobal.net>
	 <20080501173408.384b4fc3.akpm@linux-foundation.org>
	 <20080502020815.GA5155@linuxace.com>
	 <20080501192838.8ecb81c2.akpm@linux-foundation.org>
	 <20080502121945.GA18667@linuxace.com>
	 <20080502061018.5557d067.akpm@linux-foundation.org>
X-Google-Sender-Auth: 0502a424a1f7026e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 9:10 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>  Traditionally i386 never printed that message (in fact neither architecture
>  should - it allows poeple to spam the logs, but it is at least
>  ratelimited).
>

As a sysadmin I find this one of the most useful printk's ever.  When
DBAs come to me with a problem I can grep for this message and send
them off to bug the vendor without having to hunt for core dumps on
every node.  I wish it had been in the i386 kernel all along.

Lee
