Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbXHZWDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbXHZWDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbXHZWDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:03:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:47072 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbXHZWDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=pDXNY7EnI8JK2Lb9x8Ou/VEC7aHcM2wQ7xmEcoQkYFyLO/ZYEmtugEePJq5LI+xz8ZFzij0sdObIm23pYHBLNFGDNqQ415VujglqLkJH+3VxuXs4aYF/b+sntokwy9lM9qYxruXpIEB2HhQmj3FTtHW6gzR6OM+S54VXgO93HBk=
Message-ID: <fb4a4650708261502v5b64ca6ev680599ad9eb58b3@mail.gmail.com>
Date: Sun, 26 Aug 2007 19:03:00 -0300
From: "Thiago Ramos dos Santos" <dimtracker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Configuring previously loaded module
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 6557c5814013296b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have 2 devices which use the usbserial module: a CDMA modem and a
Palm PDA (to be more especific, the PDA uses the visor module, which
uses the usbserial).
When I plug the PDA to the computer, the visor module gets
automatically loaded by the kernel, and so is the usbserial module.
When the modem is pluged, the module is not loaded automaticaly, so I
created a hotplug entry for it.
For both devices I put rules in udev configuration files, so they are
autmaticaly mapped to the same /dev node in despite of the ttyUSB*
node they are mapped to.

The problem is that the modem requires the usbserial module to be
loaded with some parameters: product=xxxxx vendor=xxxxx. So, if I plug
the PDA first, the usbserial is loaded without those parameters, and
when the modem is pluged, the ttyUSB nodes are not created for it. So
I have to manually unload both the visor and usbserial modules, reload
the usbserial with the specific parameters (to get the ttyUSB nodes
for the modem) and reload the visor module (to recreate the ttyUSB
nodes for the PDA).

Is there anyway to configure the previously loaded usbserial module
with the modem parameters without having to unload it? If it is not
possible, is there any other solution?

Thanks
Thiago
