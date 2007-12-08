Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbXLHXMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbXLHXMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXLHXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:12:11 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:3855 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXLHXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qKWCu3U8HZu2V5VQy/gakkbE8+Mm4vNS5XJ8HS5D5O2XA24XJ9nBxW/GUULESg0lS3lDC3mtQi1IAUV7SKtu0KtVq5VTWFAmXsGN15k8nZoOXQT2qTVQAbtYswq+M+y2woegwcWipS8BMiSDAkfagddAP5aVVYB8BVx938vViGA=
Message-ID: <82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
Date: Sat, 8 Dec 2007 18:12:05 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
	 <20071208191330.GA21186@elte.hu>
	 <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	 <20071208194211.GA579@elte.hu>
	 <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	 <20071208201137.GA13451@elte.hu>
	 <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
	 <20071208125144.734e9f81@laptopd505.fenrus.org>
	 <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problems after disabling CONFIG_HIGHRES_TIMERS , CONFIG_CPU_IDLE
and CONFIG_NO_HZ.

I will try enabling them one by one - HRT, NOHZ and CPU_IDLE last -
that way we can at least tell what is required to be hit with this
problem.

Parag
