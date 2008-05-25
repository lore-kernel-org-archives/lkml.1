Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYEYNqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYEYNqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYEYNpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:45:52 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:57921 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYEYNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:45:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 15:45:24 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251405.05684.mb@bu3sch.de> <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
In-Reply-To: <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251545.25516.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 15:19:37 Marcel Holtmann wrote:
> this should all be done in userspace and not inside the kernel. Export  
> the special device versions via struct device and stop being lazy.

No. Wait. It's not exactly going to work this way.
You're not going to break my ABI and then tell me I'm going to work around
that, right? Answer: No.

b43 will use the slash in request_firmware. That is not going to change.

This is _exactly_ what users are so tired about. Every now and then people
decide to change some ABI.

-- 
Greetings Michael.
