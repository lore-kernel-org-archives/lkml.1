Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbZEFR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbZEFR5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbZEFR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:57:10 -0400
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:50409 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756081AbZEFR5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:57:08 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Input: add MAX7359 key switch controller driver
Date: Wed, 6 May 2009 13:57:05 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090172C682@mi8nycmail19.Mi8.com>
In-Reply-To: <5d5443650905060638l52b3c17dle0d138b689a23252@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Input: add MAX7359 key switch controller driver
Thread-Index: AcnOUOZ12sEBvfjiQAKEw41JjGoxpwAIYaog
References: <4A012C64.1020101@samsung.com> <5d5443650905060638l52b3c17dle0d138b689a23252@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Trilok Soni" <soni.trilok@gmail.com>, "Kim Kyuwon" <q1.kim@samsung.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       <linux-input@vger.kernel.org>,
       "Kyungmin Park" <kyungmin.park@samsung.com>,
       "Marek Szyprowski" <m.szyprowski@samsung.com>,
       <linux-i2c@vger.kernel.org>, "Jean Delvare" <khali@linux-fr.org>
X-OriginalArrivalTime: 06 May 2009 17:57:06.0188 (UTC) FILETIME=[117FB4C0:01C9CE74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 06, 2009 6:38 AM, Trilok Soni wrote:
>> +
>> +#define KEY(row, col, val)     (((row) << 28) | ((col) << 24) | (val))
>
> Looks like this macro is highly used by many input drivers, anyone
> looking at it to place it at common location?

Hello,

I submitted a patch series around early Feb that did just that. The only
archive for linux-input that I can find to reference the original submit
is at http://markmail.org/browse/org.kernel.vger.linux-input/2009-01.
The first message in the series is $SUBJECT
"[PATCH 0/5] input: Common macro for keypad drivers".

At this point the series would probably need to be updated.  If wanted I
will create a new one.

Regards,
Hartley
