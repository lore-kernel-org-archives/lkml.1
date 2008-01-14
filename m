Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYANTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYANTzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYANTzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:55:08 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:45984 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYANTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:55:07 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Gene Heskett <gene.heskett@gmail.com>
In-Reply-To: <200801141434.00934.gene.heskett@gmail.com>
Subject: Re: Possibly silly Q?
References: <200801141434.00934.gene.heskett@gmail.com>
Message-Id: <E45F927D-CD7D-48FB-B495-A28CF48F33FB@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Date: Mon, 14 Jan 2008 19:55:01 +0000
Cc: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 14 Jan 2008, at 19:34, Gene Heskett wrote:
> Do we have a utility that can force the kernel to re-read, and re- 
> initialize
> itself to a given drives partition tables without having to reboot  
> if one is
> working with a drive that is not part of the required kernel  
> directory tree?


Yes, the blockdev utility.  You want the --rereadpt option, i.e.

blockdev --rereadpt /dev/sdc

It is part of the util-linux package.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

