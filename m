Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464Ab0ANTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0ANTJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902Ab0ANTJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:09:37 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:59314 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0ANTJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:09:36 -0500
Message-ID: <4B4F6BE5.2040102@iki.fi>
Date: Thu, 14 Jan 2010 21:09:25 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, add IR support for digivox
 mini II
References: <1263412807-23350-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1263412807-23350-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.220
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 10:00 PM, Jiri Slaby wrote:
> MSI digivox mini II works even with remote=2 module parameter. Check
> for manufacturer and if it is Afatech, use af9015_ir_table_msi and
> af9015_rc_keys_msi.
>
> The device itself is 15a4:9016.

NACK

Device ID 15a4:9016 is reference design ID and it is used by vary many 
devices. Also manufacturer string "Afatech" is chipset default one. This 
leads MSI remote in question configured for many devices using default / 
reference values which I don't like good idea. Strings and other USB 
settings are stored to the device eeprom.

Empia (em28xx) driver uses eeprom hashing for identifying reference ID 
devices. This approach is better because it uses all eeprom bytes. I 
hope you could implement similar eeprom hashing to af9015.

regards
Antti
-- 
http://palosaari.fi/
