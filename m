Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYFVIzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYFVIzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 04:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYFVIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 04:54:59 -0400
Received: from mx2.digadd.de ([195.47.195.236]:44355 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYFVIy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 04:54:58 -0400
X-Greylist: delayed 2129 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jun 2008 04:54:58 EDT
Message-ID: <485E0B1C.7030105@digadd.de>
Date: Sun, 22 Jun 2008 11:19:40 +0300
From: "Christian P. Schmidt" <schmidt@digadd.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sending UDP packets to port 0
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I know that the kernel forbids sending UDP packets to port 0. Is there a 
specific reason for this?

I'm asking because I regularly need to access a device that asks for 
tftp files using port 0 as source. To use these devices I'm using a 
kernel with removed port 0 checks.

I read RFC 768, and it does not explicitly forbid the use of port 0 as 
far as I can see. It only says that if unused, 0 is to be inserted.

RFC 1350 (TFTP) even states explicitly:
The transfer identifiers (TID's) used by TFTP are passed to the Datagram 
layer to be used as ports; therefore they must be between 0 and 65,535.

In my understanding, and apparently that of the authors of the 
appliance's tftp client implementation, this marks port 0 as valid.

Please CC: me on any replies as I am not subscribed to the list.

Regards,
Chris
