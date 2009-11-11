Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZKKKzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZKKKzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZKKKzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:55:04 -0500
Received: from ns.firmix.at ([62.141.48.66]:2258 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZKKKzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:55:03 -0500
Subject: Re: i686 quirk for AMD Geode
From: Bernd Petrovitsch <bernd@firmix.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: Willy Tarreau <w@1wt.eu>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091110205445.GB1407@ucw.cz>
References: <20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com>
	 <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk>
	 <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
	 <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com>
	 <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu>
	 <20091110205445.GB1407@ucw.cz>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 11 Nov 2009 11:54:46 +0100
Message-Id: <1257936886.27014.15.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.285 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.285 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Wed, 11 Nov 2009 11:55:07 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, 2009-11-10 at 21:54 +0100, Pavel Machek wrote:
[...]
> > CMOV/NOPL are rarely used, thus have no reason to cause a massive
> > performance drop, but are frequent enough (at least cmov) for almost
> 
> *One* CMOV in the inner loop will make your performance go down 20x.
But it runs.
The pragmatic side is:
If people notices the performance drop, it would be good to have
something in syslog and/or dmesg and/or /proc and/or sysfs
If people do not notice the performance drop, who cares?

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


