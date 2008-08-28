Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYH1Kmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYH1Kmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYH1KmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:42:25 -0400
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27282 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751503AbYH1KmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:42:24 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 06:42:23 EDT
From: Bruno Randolf <bruno@thinktube.com>
Organization: thinktube
To: Tomas Winkler <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Thu, 28 Aug 2008 12:35:34 +0200
User-Agent: KMail/1.9.9
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080827013009.GA15781@tuxdriver.com> <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com> <20080827233103.GE5927@tesla>
In-Reply-To: <20080827233103.GE5927@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281235.35449.bruno@thinktube.com>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 04:11:15PM -0700, Tomas Winkler wrote:
> Last solution would be to remove this merging all together but then
> I'm not sure if Bruno added this code just implement the spec or
> really tested it with any hardware.

of course i tested IBSS merge with atheros hardware when i sent in the patch 
and it worked. this is about 6 month ago. recently i briefly tested IBSS, 
with the same HW but it did not work any more - i didn't have the time to 
investigate this issue...

please remember that there was a lengthy discussion about the standard 
compliance and the reasons behind the need for IBSS merge before my patch was 
accepted. i believe i had convincing arguments why IBSS mode does not 
reliably work at all in practice if we don't support IBSS merge.

you might want to re-read this thread:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/10278

greetings,
bruno
