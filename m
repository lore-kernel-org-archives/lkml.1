Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYKDVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYKDVst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYKDVsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:48:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:23404 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYKDVsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mWW1EHgOWGqw9OXuSw9KMNR18ryEfBq9dncCMICj8hrA89SwprTN8e50D33eMtR9zJ
         bS4DeTgjshymNsYp5/M+prCBKddIDbg2I+CD8SVsF+9K2vAdf8XHzA742b9/x5pAMKCi
         0vOccZJIygbL9lkXAQe56nPyB5eZd1VazufFM=
Message-ID: <4910C32F.9060204@gmail.com>
Date: Tue, 04 Nov 2008 22:48:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Adam Nielsen <a.nielsen@shikadi.net>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: led and hid class - hid_device vs led_classdev
References: <490FFF1B.6050300@shikadi.net>
In-Reply-To: <490FFF1B.6050300@shikadi.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2008 08:51 AM, Adam Nielsen wrote:
> /* Callback function when user wants to change LED state */
> static void my_led_set(struct led_classdev *led_cdev,
>   enum led_brightness value)
> {
>   /* How do I get my_data back? */
> }
> 
> Hopefully this explains what I'm after - if you need me to clarify
> anything please let me know.

my_led should by part of my_data, then you do
my_data = container_of(led_cdev, /*typeof(my_data)*/, my_led);
