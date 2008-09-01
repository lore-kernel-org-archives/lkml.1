Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbYIANLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbYIANLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYIANLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:11:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:8334 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYIANLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZMR/xx8TOpux85HxGtSwiQJmDGLqWLEPhxlATTssUHbawvRLnGj+jPHb1vGqyi4NGy
         tyqCKAwugO0OBrV8fmenzaZJbOkQyxbSSZoL9Zyta/NVQ/Q1dXY5q10Y+Y98pc69cnsS
         5DrgBvE+RIcghP7abk+IIUjQKHUrEABrnXUTs=
Message-ID: <5ff4a1e50809010611x3d8940e0n282da0b1ec5b321b@mail.gmail.com>
Date: Mon, 1 Sep 2008 14:11:10 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: ktime_set() does not check for nanoseconds > one second
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0809011501450.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
	 <alpine.LFD.1.10.0809011317460.3243@apollo.tec.linutronix.de>
	 <5ff4a1e50809010457l7051b7e8vc7f86d68ae42e529@mail.gmail.com>
	 <alpine.LFD.1.10.0809011501450.3243@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/1 Thomas Gleixner <tglx@linutronix.de>:
>
> Won't work with arbitrary numbers. i.e. >= 2* NSEC_PER_SEC. Looking at
> it, I'm even less convinced that it is a good idea.
>
>      tglx
>

Do you have another suggestion? Or should I just account for the >= 1
sec case in the calling code?
