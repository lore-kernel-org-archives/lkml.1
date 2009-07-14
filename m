Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZGNKRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZGNKRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZGNKRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:17:15 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51457 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbZGNKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:17:15 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=NgnNa4BYe58A:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=mNOX19dFcVHLgXfqMbcA:9 a=cKy0DWkD-H2CPApk5gEA:7
 a=xyi4UKUvTanFX2mArvRP5ROYGcIA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Possible Suspend to Ram bug?
Date: Tue, 14 Jul 2009 04:17:12 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.29-2-amd64; KDE/4.3.60; x86_64; svn-990302; 2009-06-30)
References: <200907100458.27410.tfjellstrom@shaw.ca>
In-Reply-To: <200907100458.27410.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907140417.12847.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 10 2009, Thomas Fjellstrom wrote:
> I've recently gotten a new OCZ Vertex 30G SSD and have noticed that it will
> flip out the second time linux wakes up from "suspend to ram".
>
> The system will run fine for days or weeks, so long as it isn't waking up a
> second StR.
>
> Here is an example error that I get from the device (my root / device):
>
> [42018.455204] sd 0:0:0:0: [sda] Unhandled error code
> [42018.455208] sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
> driverbyte=DRIVER_OK,SUGGEST_OK
> [42018.455215] end_request: I/O error, dev sda, sector 12583031
> [42018.455221] EXT3-fs error (device sda2): ext3_get_inode_loc: unable to
> read inode block - inode=391005, block=1572871
>
> At that point using my / fs is pretty much impossible. Every single app
> fails to launch with an I/O Error, about the only command I can run in that
> state is "dmesg" in an existing konsole.
>
> I'm currently using 2.6.29-2-amd64 from debian, and am running on a
> Gigabyte MA790FXT-UD5P, with a AMD Phenom II X4 810 cpu, and 4G ram.
>
> One interesting thing to note, the file system on the Vertex SSD reports as
> clean to fsck on the next boot, while my /home which is on a Seagate
> 7200.12 drive reports with several orphaned inodes (every single time). And
> that's regardless if I use ALT+SYSRQ+S/U to try and sync everything. Also,
> ALT+SYSRQ+B doesn't work at that point, only ALT+SYSRQ+O or using the
> system power/reset buttons will work.
>
> I'm attaching the full log I was able to save from dmesg (over nfs, luckily
> that worked).

Anyone have a clue what might be wrong?

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
