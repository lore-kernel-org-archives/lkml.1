Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYHXEMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYHXEMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 00:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYHXEMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 00:12:23 -0400
Received: from ag-out-0708.google.com ([72.14.246.247]:60895 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYHXEMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 00:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:from:organization:cc:content-type:mime-version
         :x-priority:content-transfer-encoding:message-id:user-agent;
        b=a6nLUeUrXzBRLMyw2uuPuR1qnuZU4GozIlkqt7/fgvCz6OicidCNXzifYgkpo905pK
         5HZx7TwE1EEaUYE8dgBJyKiokAHXxW4n/IfgtjvtQBjza36FbzQ2DmgaIhdq/jFb2hpe
         Go/6FsdgZlG4n7kfRDNsYruF8M35HWmceIgxc=
Date: Sun, 24 Aug 2008 09:41:33 +0530
To: linux-kernel@vger.kernel.org
Subject: better support for EV-DO AC8700 800 M usbserial modem ??
From: ctuxer <ctuxer@gmail.com>
Organization: ctuxer
Cc: eerpini@gmail.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
X-Priority: 1 (Highest)
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugdhwas9jwzwy4@localhost.localdomain>
User-Agent: Opera Mail/9.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi everyone ,

i have been using the EVDO AC8700 modem (usbserial) with kernel 2.6.26.2 ,  
it uses the 'option' module along with the generic usbserial module . Well  
i am happy for the improved support for the modem handling in the new  
kernels( like now i don have to modprobe with the vendor and product IDs )  
, there is one point specific to this modem which is still not handled ,  
..... the modem switches between EVDO and CDMA mode when the signal  
strength is low or when there is a bandwidth overload at the vendor's( the  
service provider , bsnl in my case )  tower . This switch in the mode is  
not recognised by the driver and the connection is lost once this  
switching occurs . I have to restart the wvdial program to reconnect .

But if the modem were in CDMA mode when i connect , then the connection is  
not lost when the modem switches back from CDMA to EVDO . I really don  
know enough to understand what is the difference between the two cases or  
what can be done to improve the support for this usbserial modem , ... can  
anyone help ?

Thanks in advance

Satish

-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
