Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZECXRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZECXRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZECXRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:17:40 -0400
Received: from a.mail.sonic.net ([64.142.16.245]:34707 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZECXRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:17:39 -0400
X-Greylist: delayed 1371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 May 2009 19:17:39 EDT
From: Jason Riedy <jason@acm.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller question)
In-Reply-To: <49FE038F.2040704@gmail.com> (Robert Hancock's message of "Sun,
	03 May 2009 14:50:23 -0600")
Date: Sun, 03 May 2009 18:35:41 -0400
Message-ID: <874ow1ak76.fsf@sparse.dyndns.org>
References: <E1LzLgA-0004j6-9W@closure.thunk.org>
	<49F90CA2.4080602@garzik.org>
	<20090430083309.437f9248@lithium.local.net>
	<49F95719.10701@kernel.org>
	<20090430144702.46415b90@lxorguk.ukuu.org.uk>
	<20090430153508.GA10704@linux.intel.com>
	<20090430154701.GA27737@srcf.ucam.org> <49FA5519.9000107@gmail.com>
	<49FCFC5D.5050303@kernel.org> <49FE038F.2040704@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEUZFRhKQ0QUEBIgHiE3
 MDNcW1ueoKXXg/zVAAACH0lEQVQ4y23TzXbbIBAF4InU7jtH0LVC0r1slL0I4+w5Bu9zGvH+j9A7
 SE6j02pl82n4mYuo4Kk/yPtpmron72fv/fmZL4Tx9drjn99A8Eu6oHBbvT/CvDwbQL0GadDvICI0
 ANYTcwRQv60xAxahcvtdSgIQUTdqJSA0sLWWwft+Fs9sWQA8nABvta7Giylp0a2XYoSvQXelwHj5
 DiUpSKm1Jj5ASTmQf4HoOF82WJsALimkHSaLicsnXHIb55CmYHcojKkkc1AQngLbcgd6yJIUTJzN
 GaecWSETDmYVIrkHHrZ2hgboUQkcJ6KXZPpNToAkfl4F8RBWMNu4j5esbS+5NdcbmeMGIqmBbEGh
 fQu1yYS1VzXFJp3mAACJbRVoc/QTAfyrox42B4UPQU1HCvHVjT1BpACubzUvnXNOLmbRCsj8U6FW
 mZzrHLIfHLVn1uuTAV7hATDqcE9ed5U2oO4RDescoQdfAa8+4ujuCMZ3DWx2bmwgendrzQqYyqb/
 ASrKDpOfD2DsPzCdG4SEg+p++x0+ljNe/GYCnze4V7wvOtUOfqvAvbhDn4VfndNmocIyYF3oCWse
 gBtEevIH8H+hVcgOvQI+nBpJt2+Qret6hPkJww5hGRVGTIzrii/nShpEkBDb0Uc6Aq5JHHXjI7Li
 BrnBScLgNBm9Eg1uua3xnTUpBODuFbc0OcCvwvK1wq4bICkNX4F2sABSiJ/wBwIJ0xBa4jcLAAAA
 AElFTkSuQmCC
X-Url: http://jriedy.users.sonic.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And Robert Hancock writes:
> Well, it's a potential concern, but it's simple enough I doubt it
> would really result in much of a burden.

My D620 is one of those that corrupted the file system with the
force-AHCI patch.  If I hadn't applied the patch externally, I might
have guessed it was the file system code...  Given all the churn in the
fs code right now, is it wise to add another *known* corruption vector?

Jason
