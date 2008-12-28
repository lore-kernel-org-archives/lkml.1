Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYL1Ikh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYL1Ikh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 03:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYL1Ik3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 03:40:29 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:36213 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYL1Ik2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 03:40:28 -0500
From: "Tigran Grigoryan" <tigrangr@synopsys.COM>
To: "'Greg KH'" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>,
       "'Tigran Grigoryan'" <tigrangr@synopsys.COM>
References: <006501c96803$bb2f4e40$318deac0$@com> <20081228060533.GA5118@kroah.com>
In-Reply-To: <20081228060533.GA5118@kroah.com>
Subject: RE: usb_create_hcd calls dev_set_drvdata
Date: Sun, 28 Dec 2008 12:40:21 +0400
Message-ID: <000f01c968c7$ed113bc0$c733b340$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aclost+AqH1GTw2sT3O9UFUN1ah9GQAFDjmg
Content-Language: en-us
x-cr-puzzleid: {B28ACE5C-C00D-4BBC-935E-DC144A909230}
x-cr-hashedpuzzle: BUQD B4Co E1lh G4fv KVry M/0i RsfL R+Lt U+1f Wn0S cOkp dLch e7H9 fF5E gXsK gqE9;3;ZwByAGUAZwBAAGsAcgBvAGEAaAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAaQBnAHIAYQBuAGcAcgBAAHMAeQBuAG8AcABzAHkAcwAuAGMAbwBtAA==;Sosha1_v1;7;{B28ACE5C-C00D-4BBC-935E-DC144A909230};dABpAGcAcgBhAG4AZwByAEAAcwB5AG4AbwBwAHMAeQBzAC4AYwBvAG0A;Sun, 28 Dec 2008 08:40:03 GMT;UgBFADoAIAB1AHMAYgBfAGMAcgBlAGEAdABlAF8AaABjAGQAIABjAGEAbABsAHMAIABkAGUAdgBfAHMAZQB0AF8AZAByAHYAZABhAHQAYQA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi,
>> 
>> Why usb_create_hcd calls dev_set_drvdata and never uses that data.

>Are you sure about that?

>> OTG device drivers may want to set their own data.

>Yes, and is this a problem?

>I'm confused to what exactly is wrong here.  Does the new OTG drivers
>not work for you, or are you writing a new one?

Actually it is not a problem, just OTG driver have to overwrite driver data
set by usb_create_hcd.

Thanks,
Tigran

