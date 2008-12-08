Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYLHWdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYLHWdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYLHWda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:33:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:7583 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYLHWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:33:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O0cwV7cKqYIVwz+3hx0+XkiNND7RjslVPDTngj4krAtTFeoep67M2SmdloKg9TdTlf
         ezNb/0RlpKCT8BCXh3rBmzu5zsl2W/6IOlouPwDRrVgpCOx68nkdQ7cAa6Rq/r7M9JBw
         t1egUrTjf60DnvB+4h0wUQkWTMiWrjf+s2g3A=
Message-ID: <c62985530812081433o5125f08gb7cad0d33a1b4104@mail.gmail.com>
Date: Mon, 8 Dec 2008 23:33:27 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: How to check for memory leaks
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <493D9D24.8080406@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493D9D24.8080406@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/8 Larry Finger <Larry.Finger@lwfinger.net>:
> What is the best way to check if there is a memory leak?
>
> If I start a ping running on my system using the rtl8187 driver, and nothing
> else active on my system, I see an increase in the "slab" value in /proc/meminfo
> of about 65 kB/minute. Is this indicative of a memory leak? When I run the same
> test with p54usb, the increase is only 20 kB/min.
>
> Thanks,
>
> Larry


Hi,

You could have a look on kmemleak: http://www.procode.org/kmemleak/
It's up to date version is on the arm development git branch (topic kmemleak):
http://www.linux-arm.org/git?p=linux-2.6.git;a=summary
