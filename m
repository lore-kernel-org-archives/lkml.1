Return-Path: <linux-kernel-owner+w=401wt.eu-S964958AbXCFLII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbXCFLII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXCFLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:08:07 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:58007 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbXCFLIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:08:06 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] OOPS with 2.6.20 and 2.6.21-rc2 (mos7720)
Date: Tue, 6 Mar 2007 12:07:53 +0100
User-Agent: KMail/1.9.1
Cc: Dirk Schoebel <dirk@liji-und-dirk.de>, linux-kernel@vger.kernel.org
References: <esjg1h$l8d$1@sea.gmane.org>
In-Reply-To: <esjg1h$l8d$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703061207.53484.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 6. März 2007 11:33 schrieb Dirk Schoebel:
> when trying to access /dev/ttyUSB0, which is a port on a dual port
> usb-serial cable (mos7720 based) an kernel OOPS happens
> the driver loads ok, first access via minicom -> OOPS
> (config.gz attached)

Please apply:
ftp://ftp.kernel.org/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/usb-fix-usb-serial-device-naming-bug.patch
ftp://ftp.kernel.org/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb/usb-further-fix-for-usb-serial.patch

	HTH
		Oliver
