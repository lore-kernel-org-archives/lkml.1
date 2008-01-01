Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAAXIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAAXIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYAAXH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:07:57 -0500
Received: from ns.firmix.at ([62.141.48.66]:2617 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbYAAXH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:07:56 -0500
Subject: Re: Get physical MAC address
From: Bernd Petrovitsch <bernd@firmix.at>
To: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 02 Jan 2008 00:07:28 +0100
Message-Id: <1199228848.3912.651.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-31 at 12:39 +0700, Theewara Vorakosit wrote:
[...]
> I get MAC address from ioctl. However, ifconfig can change this  MAC 
> address. Can I get a real physical MAC address of the NIC?

- You can get the initial MAC address right after bootup before anyone
  changes it.
- Some (if not many if not all) of the drivers output it on
  driver initialization time so you could read it from `dmesg` or
  some /var/log/messages or .....
There is no "get initial MAC address" ioctl (but it's not that
complicated to implement it).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

