Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZAMSfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZAMSfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZAMSel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:34:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35951 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZAMSej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IvUGXkSywkDQ/koUxjybcaiiybTgP1mGuXear4id3J9OwblyCzK92dRwWlsHUCeMJ5
         2i4GbNmVc8bSRckHKZZAOzHE1ovrfW4EAm7bQ1VYqWOSnSaWbg4QMeYQHMXVbMFAd5cv
         i14zy5QQiit3G4DkcJOHw7gNmnWQni/FX4aAs=
Message-ID: <8db1092f0901131034i62780d1fu37459186619e74ee@mail.gmail.com>
Date: Tue, 13 Jan 2009 19:34:33 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [2.6.29-rc1] Problem with using bluetooth adaper connected to usb port
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until 2.6.28 I use hci_usb driver to bluetooth adapter. In 2.6.29-rc1
it doesn't exists, so I switch to btusb module, and I have problem
connect with another machine, dmesg shows this message:
[  101.468638] hci_cmd_task: hci0 command tx timeout
[  699.328112] hci_cmd_task: hci0 command tx timeout

How to check what cause problems with communication?

Contents /proc/bus/usb/devicec, dmesg, lsusb, config:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/bluetooth/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
