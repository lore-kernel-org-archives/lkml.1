Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZCWSlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZCWSlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZCWSlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:41:22 -0400
Received: from frontend-1.servers.ua.pt ([193.136.173.2]:58465 "EHLO
	cgpmail.ua.pt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbZCWSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:41:21 -0400
X-Greylist: delayed 7202 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 14:41:21 EDT
From: "Tiago Manuel Nunes Marques" <a28427@alunos.det.ua.pt>
Subject: Assignment of network interface names at boot time
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser v5.1.13
Date: Mon, 23 Mar 2009 16:41:16 +0000
Message-ID: <web-75609548@controller.cgpmail.ua.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I don't know if this would be more appropriate to submit 
as a bug report but I would like to know where I could 
start tackling this issue instead of submitting a bug 
report.

I administer a small cluster which I have now started to 
migrate to diskless root but I seem to be having problems 
with the network interfaces, which, on boot, are randomly 
assigned eth0 or eth1. This is a behavior that I didn't 
experienced in 2.6.24 but 2.6.26 has some patches that I 
would like to have.

UDEV rules are not a solution, since I need to boot from 
the interface, hopefully having a way to define the same 
interface to all the machines, for instance: have lower 
MAC interfaces be eth0, boot from them, having the network 
administrator change these interfaces for the PXE network, 
if necessary. Right now, sometimes the test machine boots, 
sometimes it gives eth0 to the other interface and fails 
to mount the root filesystem.

Where can I start, as this been tackled yet? I searched 
google but found no one with the same issues.

Best regards,

                          Tiago Marques
