Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYAWWYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYAWWYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYAWWXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:23:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:17126 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYAWWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DZ6h6M2A3qmK7rMWA1fscfH2qkQMKSR4NeRgsiICM1hK7SCqUXm3yxg4R2e+P8V5S8SvDqoFrE4d6BlwaxTdXtXYh3EQhCNotHUFpxzZCdsq8X1OppO1q+AtgsLh2hvAdgrNgs7L2VENweh+OzZVEZcdJd33BBbSR324xkNXwBE=
From: Marcin Gil <marcin.gil@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: JMicron PATA 2.6.24-rc7 can't find drives
Date: Wed, 23 Jan 2008 23:23:36 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801232323.36187.marcin.gil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have Asus p5b-v motherboard with Intel ICH8R + JMicron 20360/20363.

I am currently using zen-sources 2.6.24-rc7-zen2-g7c7e9c4a
(zen-sources.org) based on kernel 2.6.24-rc7. I have also these sources
directly with no solution to below problem (the mm-sources also don't help).

I have ATA turned off completely and SCSI stuff (generic, disk, cdrom) 
compiled in. SATA for Intel ICH8, AHCI also compiled in. JMicron PATA as a 
module.

I have SATA drive connected to SATA0 and Maxtor IDE drive + DVD burner 
connected to single IDE slot.

Booting this kernel off the SATA drive works perfectly, however the IDE drive 
is not found/put into /dev. However the DVD is properly recognized and 
created as sr0.

Is this known problem? I've looked all over google and found out that people 
have problems with CD/DVD drives with pata_jmicron but in my case DVD is 
working ok but HDD is not.

Is there a solution for this or can I give you more information to help me 
solve this?

Thank you for your time and patience.
-Marcin Gil

PS. Please CC all answers to me as I have not joined the list.
