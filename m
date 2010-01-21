Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453Ab0AUMTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0AUMTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398Ab0AUMTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:19:22 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44273 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0AUMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gso4wCDnnIrlsoM/rjPWAtwrX+6S6wpGqB4HXIaFYK7IReGmDW7SukWPTmNaCsOsnN
         kIBzM0rQGfJ5if82yB4CaiwLk8k8XcN5JFP/Ds9HlOvzyNV0Cf2roLk4dQb9Mglv7hoH
         szNb8wb1P9/hZRsz0lDg6JTrxvwo12QtefzQU=
MIME-Version: 1.0
In-Reply-To: <20100121111850.GD5017@nowhere>
References: <ff13bc9a1001210310x5ebc9993kbf6b302285d2d9a4@mail.gmail.com>
	 <20100121111850.GD5017@nowhere>
Date: Thu, 21 Jan 2010 13:19:19 +0100
X-Google-Sender-Auth: 199c169927cfae91
Message-ID: <ff13bc9a1001210419x892b031qaf3fffe492bfd9ca@mail.gmail.com>
Subject: Re: perf record -g hangs the system
From: Luca Barbieri <luca@luca-barbieri.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.
Switching to Linus master fixed that issue, and that commit was almost
surely responsible for that.
