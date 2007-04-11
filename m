Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDKRPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDKRPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXDKRPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:15:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34104 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbXDKRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:15:06 -0400
Date: Wed, 11 Apr 2007 19:03:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Phillip Susi <psusi@cfl.rr.com>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <m3mz1e275x.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.61.0704111902400.20436@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100353.14208.gene.heskett@gmail.com> <461BDFEA.8040602@cfl.rr.com>
 <200704110001.40573.gene.heskett@gmail.com> <461CF4D9.2000302@cfl.rr.com>
 <alpine.DEB.0.83.0704111109390.13251@sigma.j-a-k-j.com> <m3mz1e275x.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 18:43, Krzysztof Halasa wrote:
>"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
>
>> I think that's especially true. If a user begins with a single full disk 
>> for their entire filesystem, uses tar to backup, and then later adds a 
>> second disk, copies everything from /usr and /home onto partitions there 
>> (making sure to preserve all interesting bits like ctime/mtime), and 
>> mounts them over the original directories, tar should not decide that 
>> every file in /usr and /home was deleted and recreated.
>
>That wouldn't work, even if you managed to copy ctime, the target
>inode number will be different than the original and backup has
>to assume it's a different file.

Time for rsync and/or rsync -c. And some target filesystem that is
fused to a [can-be-]non-solid archive, like 7z.


Jan
-- 
