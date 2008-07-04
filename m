Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYGDLHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYGDLHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYGDLHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:07:03 -0400
Received: from mailer1.option.com ([81.246.70.162]:42491 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYGDLHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:07:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUAAIGgbUgKAAAZ/2dsb2JhbAAIsHpA
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: AW: tcp/ip connect on demand
Date: Fri, 4 Jul 2008 13:04:40 +0200
Message-ID: <F67862BE33DC784289A6B34E92908FCF394007@SRV-SATURNUS.OPTION.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tcp/ip connect on demand
Thread-Index: AcjdQTglR4sCRP4ESWKubhxEt9ZwfQAhIkjk
References: <F67862BE33DC784289A6B34E92908FCF393FFE@SRV-SATURNUS.OPTION.local> <486D1A66.6010006@zytor.com> <alpine.LNX.1.10.0807032106310.23294@fbirervta.pbzchgretzou.qr> <486D2564.4030806@zytor.com>
From: "Jens-Michael Hoffmann" <J.Hoffmann@option.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jan Engelhardt" <jengelh@medozas.de>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Jan Engelhardt wrote:
>> On Thursday 2008-07-03 20:28, H. Peter Anvin wrote:
>>> Jens-Michael Hoffmann wrote:
>>>> hi,
>>>>
>>>> what is the right way to implement a "connect on demand" feature?
>>>> Example: user types url in firefox and presses return. Then
>>>> the system should set up network devices and proceed as usual.
>>>>
>>>> Is there a hook in the kernel we can use?
>>> In the kernel, no.  Nor do you need one; the best place to hook into this is
>>> probably the name service system (so you catch it on trying to look up
>>> hostnames.)
>>>
>>> Alternatively, you can set up a bridge device which you can listen to via a tap
>>> device; when you see traffic, you bring up the real network and attach it to
>>> the bridge.
>> 
>> There is on-demand for PPP devices; though that is probably specific
>> to PPP.

> Yes, those monitor traffic at the PPP device port, I believe.

thanks for the help guys, that looks like what we are looking for.

Best regards

Jens-Michael Hoffmann
