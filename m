Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZCROer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZCROer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZCROee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:34:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:23330 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZCROed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dH9xhlwgySF0Y0IMJ1mQgA/BmEioVZXHtFR1eVZmx+Js29s9QS6N7QxKEMb8k/5Ppj
         0MCSNO8RmOHYFx2f0CvXoMlppgOEL141c8DEzIWU8MCU3v1tzeXyEEswajvVAb6al6C4
         i6/RN0mg+FZwPkcGnCXfsIX9knAq3EKay/X+M=
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 17:34:30 +0300
Message-ID: <a4423d670903180734w7270a4f3qa2af3981b969436c@mail.gmail.com>
Subject: next-20090318: sunhme does not transmit packets
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ultra 10 can boot, it receives DHCP answer, ssh works, but few minutes
after machine becomes unresponsible by net at all.
It does not respond even on ARP requests.

On Sparc host I see that `TX packets` does not grow, but RX grows.
The state of the interface is
UP BROADCAST RUNNING MULTICAST

There is no relevant kernel messages in dmesg.

next-20090317 worked fine.


Let me know if I can help.
