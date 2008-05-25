Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYEYSTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYEYSTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYEYSTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:19:34 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:60112 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbYEYSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:19:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:18:58 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211722835.17151.24.camel@johannes.berg> <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org>
In-Reply-To: <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252018.58627.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 20:12:41 Marcel Holtmann wrote:
> So you actually do know how request_firmware() actually works right  
> now? You need to change the firmware_class implementation and API to  
> give it an extra parameter to allow any kind if simultaneous loading  
> within one driver. Having the FIRMWARE as environment variable is  
> actually suboptimal. You want to have the FIRMWARE environment  
> variable as bus_id for the firmware struct device object.

Can you explain _why_ we want to have this as bus_id?
I don't really understand that.

-- 
Greetings Michael.
